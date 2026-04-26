
import 'package:TR/features/home/model/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({ProductModel? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

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