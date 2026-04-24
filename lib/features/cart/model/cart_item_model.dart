
import 'package:TR/features/home/model/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromMap(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }
}