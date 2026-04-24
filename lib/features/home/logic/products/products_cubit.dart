import 'package:TR/core/errors/error_handler.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:TR/features/home/logic/products/products_state.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseServiceImpl(FirebaseFirestore.instance),
        super(ProductsInitial());

  final FirebaseService _firebaseService;

  Future<void> getAllProducts() async {
    emit(ProductsLoading());

    try {
      final querySnapshot = await _firebaseService.getCollection('products');

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromFirestore(data, doc.id);
      }).toList();

      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(products));
      }
    } on FirebaseException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(ProductsError(failure.message));
    } catch (e) {
      emit(ProductsError(ErrorHandler.unexpectedError));
    }
  }

  Future<void> getProductsByCategory(String categoryName) async {
    emit(ProductsLoading());

    try {
      if (categoryName == "All") {
        return getAllProducts();
      }

      final querySnapshot = await _firebaseService.queryCollection(
        'products',
        field: 'category',
        isEqualTo: categoryName,
      );

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromFirestore(data, doc.id);
      }).toList();

      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(products));
      }
    } on FirebaseException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(ProductsError(failure.message));
    } catch (e) {
      emit(ProductsError(ErrorHandler.unexpectedError));
    }
  }
}