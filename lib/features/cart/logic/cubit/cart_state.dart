part of 'cart_cubit.dart';


class CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartState({required this.items, required this.totalPrice});

  // حالة ابتدائية فارغة
  factory CartState.initial() => CartState(items: [], totalPrice: 0.0);
}