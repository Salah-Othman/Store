import 'package:TR/core/errors/firebase_failure.dart';
import 'package:TR/features/home/logic/products/products_state.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getAllProducts() async {
    emit(ProductsLoading());

    try {
      final querySnapshot = await _firestore
          .collection('products')
          .get()
          .timeout(const Duration(seconds: 15)); // Timeout للحماية

      final products = querySnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(products));
      }

    } on FirebaseException catch (e) {
      // هنا فصلنا FirebaseException لوحده تماماً
      final failure = FirebaseFailure.fromFirebaseException(e);
      emit(ProductsError(failure.message)); 
      
      // في الـ Production بنبعت الـ code لـ Crashlytics هنا
      // FirebaseCrashlytics.instance.recordError(e, stack);
      
    } catch (e) {
      // أي خطأ "بشري" أو Logic error تاني
      emit(ProductsError("Unexpected error occurred."));
    }
  }
}