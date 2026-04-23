import 'package:TR/core/localization/app_localizations.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw StateError('User not authenticated');
      }

      final docRef = await _firestore.collection('Orders').add({
        'userId': uid,
        'customerName': name.trim(),
        'customerPhone': phone.trim(),
        'customerAddress': address.trim(),
        'items': cartItems,
        'totalPrice': total,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

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
