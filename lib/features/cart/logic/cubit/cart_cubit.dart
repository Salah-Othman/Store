import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/cart/model/cart_item_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  final String _cartBoxName = 'cart_box';
  Box<dynamic>? _box;

  Future<void> init() async {
    try {
      _box = await Hive.openBox(_cartBoxName);
      await loadLocalCart();
    } catch (e, stackTrace) {
      debugPrint('CartCubit.init error: $e\n$stackTrace');
      emit(CartState.initial());
    }
  }

  void initTheme(BuildContext context) {
    final currentSecondary = state.secondaryColor;
    if (currentSecondary != AppTheme.secondaryColor) {
      return;
    }
    final isDesktop = context.isDesktop;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final btnTheme = theme.elevatedButtonTheme;
    final btnColor = btnTheme.style?.backgroundColor?.resolve({});

    emit(state.copyWith(
      isDesktop: isDesktop,
      isDarkMode: isDarkMode,
      scaffoldBg: scaffoldBg,
      surfaceColor: surfaceColor,
      textColor: textColor,
      secondaryColor: AppTheme.secondaryColor,
      btnColor: btnColor ?? AppTheme.secondaryColor,
    ));
  }

  Future<void> loadLocalCart() async {
    try {
      _box ??= await Hive.openBox(_cartBoxName);
      final List<dynamic>? savedItems = _box!.get('items');

      if (savedItems != null) {
        final items = savedItems
            .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
        final total = items.fold<double>(
            0.0, (sum, item) => sum + (item.product.price * item.quantity));
        emit(CartState(items: items, totalPrice: total).copyWith(
          isDesktop: state.isDesktop,
          isDarkMode: state.isDarkMode,
          scaffoldBg: state.scaffoldBg,
          surfaceColor: state.surfaceColor,
          textColor: state.textColor,
          secondaryColor: state.secondaryColor,
          btnColor: state.btnColor,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('CartCubit.loadLocalCart error: $e\n$stackTrace');
      emit(CartState.initial().copyWith(
        isDesktop: state.isDesktop,
        isDarkMode: state.isDarkMode,
        scaffoldBg: state.scaffoldBg,
        surfaceColor: state.surfaceColor,
        textColor: state.textColor,
        secondaryColor: state.secondaryColor,
        btnColor: state.btnColor,
      ));
    }
  }

  void addToCart(ProductModel product) {
    try {
      final List<CartItem> updatedItems = List.from(state.items);
      final int index =
          updatedItems.indexWhere((item) => item.product.id == product.id);

      if (index != -1) {
        updatedItems[index] = updatedItems[index].copyWith(
          quantity: updatedItems[index].quantity + 1,
        );
      } else {
        updatedItems.add(CartItem(product: product, quantity: 1));
      }
      _updateAndSave(updatedItems);
    } catch (e, stackTrace) {
      debugPrint('CartCubit.addToCart error: $e\n$stackTrace');
      rethrow;
    }
  }

  void _updateAndSave(List<CartItem> items) {
    final double total = items.fold<double>(
        0.0, (sum, item) => sum + (item.product.price * item.quantity));
    emit(CartState(items: items, totalPrice: total).copyWith(
      isDesktop: state.isDesktop,
      isDarkMode: state.isDarkMode,
      scaffoldBg: state.scaffoldBg,
      surfaceColor: state.surfaceColor,
      textColor: state.textColor,
      secondaryColor: state.secondaryColor,
      btnColor: state.btnColor,
    ));
    _saveToLocal(items);
  }

  Future<void> _saveToLocal(List<CartItem> items) async {
    try {
      _box ??= await Hive.openBox(_cartBoxName);
      await _box!.put('items', items.map((e) => e.toMap()).toList());
    } catch (e, stackTrace) {
      debugPrint('CartCubit._saveToLocal error: $e\n$stackTrace');
    }
  }

  void removeFromCart(ProductModel product) {
    try {
      final List<CartItem> currentItems = List.from(state.items);
      final int index =
          currentItems.indexWhere((item) => item.product.id == product.id);

      if (index != -1) {
        if (currentItems[index].quantity > 1) {
          currentItems[index] = currentItems[index].copyWith(
            quantity: currentItems[index].quantity - 1,
          );
        } else {
          currentItems.removeAt(index);
        }
        _updateAndSave(currentItems);
      }
    } catch (e, stackTrace) {
      debugPrint('CartCubit.removeFromCart error: $e\n$stackTrace');
      rethrow;
    }
  }

  void deleteFromCart(ProductModel product) {
    try {
      final List<CartItem> currentItems = List.from(state.items);
      currentItems.removeWhere((item) => item.product.id == product.id);
      _updateAndSave(currentItems);
    } catch (e, stackTrace) {
      debugPrint('CartCubit.deleteFromCart error: $e\n$stackTrace');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      _box ??= await Hive.openBox(_cartBoxName);
      await _box!.clear();
      emit(CartState(items: [], totalPrice: 0.0).copyWith(
        isDesktop: state.isDesktop,
        scaffoldBg: state.scaffoldBg,
        surfaceColor: state.surfaceColor,
        textColor: state.textColor,
        secondaryColor: state.secondaryColor,
        btnColor: state.btnColor,
      ));
    } catch (e, stackTrace) {
      debugPrint('CartCubit.clearCart error: $e\n$stackTrace');
      emit(CartState(items: [], totalPrice: 0.0).copyWith(
        isDesktop: state.isDesktop,
        scaffoldBg: state.scaffoldBg,
        surfaceColor: state.surfaceColor,
        textColor: state.textColor,
        secondaryColor: state.secondaryColor,
        btnColor: state.btnColor,
      ));
    }
  }
}