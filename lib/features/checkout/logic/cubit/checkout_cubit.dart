import 'package:TR/core/errors/error_handler.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({FirebaseService? firebaseService})
      : _firestore = FirebaseFirestore.instance,
        super(CheckoutInitial());

  final FirebaseFirestore _firestore;
  Color _surfaceColor = Colors.white;
  Color _textColor = Colors.black;
  Color _primaryColor = const Color(0xFF2196F3);

  void initTheme(BuildContext context) {
    final theme = Theme.of(context);
    _surfaceColor = theme.colorScheme.surface;
    _textColor = theme.colorScheme.onSurface;
    _primaryColor = theme.colorScheme.primary;

    if (state is CheckoutInitial) {
      emit((state as CheckoutInitial).copyWith(
        surfaceColor: _surfaceColor,
        textColor: _textColor,
        primaryColor: _primaryColor,
      ));
    } else {
      emit(CheckoutInitial(
        surfaceColor: _surfaceColor,
        textColor: _textColor,
        primaryColor: _primaryColor,
      ));
    }
  }

  Future<void> placeOrder({
    required String name,
    required String phone,
    required String address,
    required List<Map<String, dynamic>> cartItems,
    required double total,
  }) async {
    emit(CheckoutLoading(
      surfaceColor: _surfaceColor,
      textColor: _textColor,
      primaryColor: _primaryColor,
    ));

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(CheckoutError('User not authenticated. Please sign in.',
          surfaceColor: _surfaceColor,
          textColor: _textColor,
          primaryColor: _primaryColor,
        ));
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

      emit(CheckoutSuccess('Order placed successfully',
        surfaceColor: _surfaceColor,
        textColor: _textColor,
        primaryColor: _primaryColor,
      ));
    } on FirebaseException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(CheckoutError(failure.message,
        surfaceColor: _surfaceColor,
        textColor: _textColor,
        primaryColor: _primaryColor,
      ));
    } catch (e) {
      emit(CheckoutError(ErrorHandler.unexpectedError,
        surfaceColor: _surfaceColor,
        textColor: _textColor,
        primaryColor: _primaryColor,
      ));
    }
  }
}