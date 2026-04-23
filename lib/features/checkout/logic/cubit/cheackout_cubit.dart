import 'package:TR/core/localization/app_localizations.dart';
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
      final docRef = await _firestore.collection('Orders').add({
        'customerName': name.trim(),
        'customerPhone': phone.trim(),
        'customerAddress': address.trim(),
        'items': cartItems,
        'totalPrice': total,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final box = Hive.box('orders_box');
      final ids = List<String>.from(box.get('my_orders_ids') ?? []);
      ids.add(docRef.id);
      await box.put('my_orders_ids', ids);

      emit(CheckoutSuccess(docRef.id));
    } catch (e) {
      final settingsBox = Hive.box('settings_box');
      final languageCode =
          settingsBox.get('appLanguage', defaultValue: 'en') as String;
      final localizations = AppLocalizations.fromLanguageCode(languageCode);
      emit(CheckoutError(localizations.checkoutError));
    }
  }
}
