import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/home/model/category_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:TR/features/orders_history/model/order_history_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminState());

  void initTheme(BuildContext context) {
    final isDarkMode = Hive.box('settings_box').get('isDarkMode', defaultValue: false) as bool;
    final theme = Theme.of(context);
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final textSecondaryColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final primaryColor = AppTheme.primaryColor;

    emit(state.copyWith(
      isDarkMode: isDarkMode,
      scaffoldBg: scaffoldBg,
      surfaceColor: surfaceColor,
      textColor: textColor,
      textSecondaryColor: textSecondaryColor,
      primaryColor: primaryColor,
    ));
  }

  Future<void> checkAdminStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(isAdmin: false, isLoading: false));
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      final isAdmin = data?['role'] == 'admin' || data?['isAdmin'] == true;
      emit(state.copyWith(isAdmin: isAdmin, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isAdmin: false, isLoading: false));
    }
  }

  void updateData({
    List<ProductModel>? products,
    List<OrderModel>? orders,
    List<CategoryModel>? categories,
    List<DocumentSnapshot>? users,
    List<DocumentSnapshot>? banners,
  }) {
    final ordersList = orders ?? [];
    final totalRevenue = ordersList.fold<double>(0, (total, order) => total + order.totalPrice);
    final pendingOrders = ordersList.where((o) => o.status == 'Pending').length;
    final successOrders = ordersList.where((o) => o.status == 'Success').length;

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
    ));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  void setError(String message) {
    emit(state.copyWith(errorMessage: message, isLoading: false));
  }

  Future<void> addCategory(String name, String imageUrl) async {
    await FirebaseFirestore.instance.collection('category').add({
      'name': name,
      'imageUrl': imageUrl,
    });
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required bool isAvailable,
  }) async {
    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    });
  }

  Future<void> addBanner(String imageUrl) async {
    await FirebaseFirestore.instance.collection('banners').add({
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
      'status': status,
    });
  }

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  }

  Future<void> deleteCategory(String categoryId) async {
    await FirebaseFirestore.instance.collection('category').doc(categoryId).delete();
  }

  Future<void> deleteBanner(String bannerId) async {
    await FirebaseFirestore.instance.collection('banners').doc(bannerId).delete();
  }

  Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}