import 'package:TR/core/errors/firebase_failure.dart';
import 'package:TR/features/home/model/category_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get All Categories
  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      final querySnapshot = await _firestore.collection('category').get();

      final categories = querySnapshot.docs.map((doc) {
        return CategoryModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      emit(CategoryLoaded(categories));
    } on FirebaseException catch (e) {
      final failure = FirebaseFailure.fromFirebaseException(e);
      emit(CategoryError(failure.message));
    } catch (e) {
      emit(CategoryError("Unexpected error loading categories."));
    }
  }
}
