import 'package:TR/core/errors/error_handler.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({FirebaseService? firebaseService})
      : _firestore = FirebaseFirestore.instance,
        super(CheckoutInitial());

  final FirebaseFirestore _firestore;

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
        emit(CheckoutError('User not authenticated. Please sign in.'));
        return;
      }

      await _firestore.collection('Orders').add({
        'userId': uid,
        'customerName': name.trim(),
        'customerPhone': phone.trim(),
        'customerAddress': address.trim(),
        'items': cartItems,
        'totalPrice': total,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 30));

      emit(CheckoutSuccess('Order placed successfully'));
    } on FirebaseException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(CheckoutError(failure.message));
    } catch (e) {
      emit(CheckoutError(ErrorHandler.unexpectedError));
    }
  }
}