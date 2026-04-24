part of 'order_history_cubit.dart';

abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}
class OrderHistoryLoading extends OrderHistoryState {}
class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderModel> orders;

  OrderHistoryLoaded(this.orders);
}
class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError(this.message);
}
class OrderHistoryEmpty extends OrderHistoryState {}