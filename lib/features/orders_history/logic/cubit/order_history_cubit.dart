import 'package:TR/features/orders_history/model/order_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(OrderHistoryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchMyOrders() async {
    emit(OrderHistoryLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(OrderHistoryEmpty());
        return;
      }

      final query = await _firestore
          .collection('Orders')
          .where('userId', isEqualTo: uid)
          .get();

      final orders =
          query.docs.map((d) => OrderModel.fromFirestore(d.data(), d.id)).toList();

      // ترتيب من الأحدث للأقدم
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (orders.isEmpty) {
        emit(OrderHistoryEmpty());
      } else {
        emit(OrderHistoryLoaded(orders));
      }
    } catch (e) {
      emit(OrderHistoryError("Failed to load orders."));
    }
  }
}