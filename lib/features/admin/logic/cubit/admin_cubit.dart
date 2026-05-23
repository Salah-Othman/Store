import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/home/model/category_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:TR/features/orders_history/model/order_history_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseServiceImpl(FirebaseFirestore.instance),
        super(const AdminState());

  final FirebaseService _firebaseService;

  void updateTheme(BuildContext context) {
    final isDarkMode = Hive.box('settings_box').get('isDarkMode', defaultValue: false) as bool;
    final theme = Theme.of(context);

    emit(state.copyWith(
      isDarkMode: isDarkMode,
      scaffoldBg: theme.scaffoldBackgroundColor,
      surfaceColor: theme.colorScheme.surface,
      textColor: theme.colorScheme.onSurface,
      textSecondaryColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      primaryColor: AppTheme.primaryColor,
    ));
  }

  Future<void> init(BuildContext context) async {
    updateTheme(context);
    await checkAdminStatus();
    if (state.isAdmin) {
      await loadData();
    }
  }

  Future<void> checkAdminStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(isAdmin: false, isLoading: false));
      return;
    }

    try {
      final doc = await _firebaseService.getDocument('users', uid);
      final data = doc.data() as Map<String, dynamic>?;
      final isAdmin = data?['role'] == 'admin' || data?['isAdmin'] == true;
      emit(state.copyWith(isAdmin: isAdmin, isLoading: false));
    } catch (e) {
      developer.log('checkAdminStatus error: $e', name: 'AdminCubit');
      emit(state.copyWith(isAdmin: false, isLoading: false));
    }
  }

  Future<void> loadData() async {
    final isInitialLoad = state.products.isEmpty && state.orders.isEmpty;
    if (isInitialLoad) {
      emit(state.copyWith(isLoading: true));
    } else {
      emit(state.copyWith(isRefreshing: true));
    }
    try {
      final results = await Future.wait([
        _firebaseService.getCollection('products'),
        _firebaseService.getCollection('Orders'),
        _firebaseService.getCollection('users'),
        _firebaseService.getCollection('category'),
        _firebaseService.getCollection('banners'),
      ]);

      final products = results[0].docs
          .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      final orders = results[1].docs
          .map((doc) => OrderModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      final users = results[2].docs;
      final categories = results[3].docs
          .map((doc) => CategoryModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      final banners = results[4].docs;

      final totalRevenue = orders.fold<double>(0, (s, o) => s + o.totalPrice);
      final pendingOrders = orders.where((o) => o.status == 'Pending').length;
      final successOrders = orders.where((o) => o.status == 'Success').length;

      emit(state.copyWith(
        products: products,
        orders: orders,
        categories: categories,
        users: users,
        banners: banners,
        totalRevenue: totalRevenue,
        pendingOrders: pendingOrders,
        successOrders: successOrders,
        isLoading: false,
        isRefreshing: false,
        errorMessage: null,
      ));
    } catch (e) {
      developer.log('loadData error: $e', name: 'AdminCubit');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false, isRefreshing: false));
    }
  }

  Future<void> addCategory(String name, String imageUrl) async {
    await _firebaseService.addDocument('category', {
      'name': name,
      'imageUrl': imageUrl,
    });
    await loadData();
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required bool isAvailable,
  }) async {
    await _firebaseService.addDocument('products', {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    });
    await loadData();
  }

  Future<void> addBanner(String imageUrl) async {
    await FirebaseFirestore.instance.collection('banners').add({
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await loadData();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firebaseService.updateDocument('Orders', orderId, {
      'status': status,
    });
    await loadData();
  }

  Future<void> deleteProduct(String productId) async {
    await _firebaseService.deleteDocument('products', productId);
    await loadData();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firebaseService.deleteDocument('category', categoryId);
    await loadData();
  }

  Future<void> deleteBanner(String bannerId) async {
    await _firebaseService.deleteDocument('banners', bannerId);
    await loadData();
  }

  Future<void> deleteUser(String userId) async {
    await _firebaseService.deleteDocument('users', userId);
    await loadData();
  }
}