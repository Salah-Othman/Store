import 'package:TR/features/orders_history/model/order_history_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(OrderHistoryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchMyOrders() async {
    emit(OrderHistoryLoading());
    try {
      // 1. جلب الـ IDs المحفوظة محلياً في Hive (التي خُزنت عند الـ Checkout)
      var box = Hive.box('orders_box');
      List<String> orderIds = List<String>.from(box.get('my_orders_ids') ?? []);

      if (orderIds.isEmpty) {
        emit(OrderHistoryEmpty());
        return;
      }

      // 2. جلب تفاصيل الطلبات من Firestore
      List<OrderModel> orders = [];
      for (var id in orderIds) {
        var doc = await _firestore.collection('Orders').doc(id).get();
        if (doc.exists) {
          orders.add(OrderModel.fromFirestore(doc.data()!, doc.id));
        }
      }

      // ترتيب من الأحدث للأقدم
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderHistoryError("Failed to load orders."));
    }
  }
}