
import 'package:TR/features/home/model/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}
class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  ProductsLoaded(this.products);
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
class ProductsEmpty extends ProductsState {
   final String message = 'No products available at the moment';
  ProductsEmpty();
}
