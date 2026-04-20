import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';

part 'cheackout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder({
    required String name,
    required String phone,
    required String address,
    required List<Map<String, dynamic>> cartItems,
    required double total,
  }) async {
    emit(CheckoutLoading());

    try {
      // إرسال البيانات كـ Guest Order
      DocumentReference docRef = await _firestore.collection('Orders').add({
        'customerName': name.trim(),
        'customerPhone': phone.trim(),
        'customerAddress': address.trim(),
        'items': cartItems,
        'totalPrice': total,
        'status': 'Pending', // حالة الطلب للمدير
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(CheckoutSuccess(docRef.id));

      // داخل CheckoutCubit عند النجاح
      var box = Hive.box('orders_box');
      List<String> ids = List<String>.from(box.get('my_orders_ids') ?? []);
      ids.add(docRef.id);
      await box.put('my_orders_ids', ids);
    } catch (e) {
      emit(CheckoutError("حدث خطأ أثناء إرسال الطلب، حاول مرة أخرى."));
    }
  }
}
