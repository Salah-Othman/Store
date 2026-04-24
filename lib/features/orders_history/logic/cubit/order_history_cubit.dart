import 'package:TR/core/errors/error_handler.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:TR/features/orders_history/model/order_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseServiceImpl(FirebaseFirestore.instance),
        super(OrderHistoryInitial());

  final FirebaseService _firebaseService;

  Future<void> fetchMyOrders() async {
    emit(OrderHistoryLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(OrderHistoryEmpty());
        return;
      }

      final querySnapshot = await _firebaseService.queryCollection(
        'Orders',
        field: 'userId',
        isEqualTo: uid,
      );

      final orders = querySnapshot.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        return OrderModel.fromFirestore(data, d.id);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (orders.isEmpty) {
        emit(OrderHistoryEmpty());
      } else {
        emit(OrderHistoryLoaded(orders));
      }
    } on FirebaseException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(OrderHistoryError(failure.message));
    } catch (e) {
      emit(OrderHistoryError(ErrorHandler.unexpectedError));
    }
  }
}