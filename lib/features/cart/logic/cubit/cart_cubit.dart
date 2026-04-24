import 'package:TR/features/cart/model/cart_item_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  final String _cartBoxName = 'cart_box';
  Box? _box;

  Future<void> init() async {
    try {
      _box = await Hive.openBox(_cartBoxName);
      await loadLocalCart();
    } catch (e) {
      emit(CartState.initial());
    }
  }

  Future<void> loadLocalCart() async {
    try {
      _box ??= Hive.box(_cartBoxName);
      final List? savedItems = _box!.get('items');

      if (savedItems != null) {
        final items = savedItems
            .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        final total = items.fold(
            0.0, (sum, item) => sum + (item.product.price * item.quantity));
        emit(CartState(items: items, totalPrice: total));
      }
    } catch (e) {
      emit(CartState.initial());
    }
  }

  void addToCart(ProductModel product) {
    try {
      final List<CartItem> updatedItems = List.from(state.items);
      int index =
          updatedItems.indexWhere((item) => item.product.id == product.id);

      if (index != -1) {
        updatedItems[index].quantity += 1;
      } else {
        updatedItems.add(CartItem(product: product, quantity: 1));
      }
      _updateAndSave(updatedItems);
    } catch (e) {
      // Silent fail for add operation
    }
  }

  void _updateAndSave(List<CartItem> items) {
    try {
      double total = items.fold(
          0.0, (sum, item) => sum + (item.product.price * item.quantity));
      emit(CartState(items: items, totalPrice: total));
      _saveToLocal(items);
    } catch (e) {
      final total = items.fold(
          0.0, (sum, item) => sum + (item.product.price * item.quantity));
      emit(CartState(items: items, totalPrice: total));
    }
  }

  Future<void> _saveToLocal(List<CartItem> items) async {
    try {
      _box ??= Hive.box(_cartBoxName);
      await _box!.put('items', items.map((e) => e.toMap()).toList());
    } catch (e) {
      // Silent fail for save
    }
  }

  void removeFromCart(ProductModel product) {
    try {
      final List<CartItem> currentItems = List.from(state.items);
      int index =
          currentItems.indexWhere((item) => item.product.id == product.id);

      if (index != -1) {
        if (currentItems[index].quantity > 1) {
          currentItems[index].quantity -= 1;
        } else {
          currentItems.removeAt(index);
        }
        _updateAndSave(currentItems);
      }
    } catch (e) {
      // Silent fail for remove
    }
  }

  void deleteFromCart(ProductModel product) {
    try {
      final List<CartItem> currentItems = List.from(state.items);
      currentItems.removeWhere((item) => item.product.id == product.id);
      _updateAndSave(currentItems);
    } catch (e) {
      // Silent fail for delete
    }
  }

  Future<void> clearCart() async {
    try {
      _box ??= Hive.box(_cartBoxName);
      await _box!.clear();
      emit(CartState(items: [], totalPrice: 0.0));
    } catch (e) {
      emit(CartState(items: [], totalPrice: 0.0));
    }
  }
}