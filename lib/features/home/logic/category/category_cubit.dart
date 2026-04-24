import 'package:TR/core/errors/error_handler.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:TR/features/home/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseServiceImpl(FirebaseFirestore.instance),
        super(CategoryInitial());

  final FirebaseService _firebaseService;

  Future<void> getCategories() async {
    emit(CategoryLoading());

    try {
      final querySnapshot = await _firebaseService.getCollection('category');

      final categories = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CategoryModel.fromFirestore(data, doc.id);
      }).toList();

      emit(CategoryLoaded(categories));
    } on FirebaseException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(CategoryError(failure.message));
    } catch (e) {
      emit(CategoryError(ErrorHandler.unexpectedError));
    }
  }
}