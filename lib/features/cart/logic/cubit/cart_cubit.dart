import 'package:TR/features/cart/model/cart_item_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';

part 'cart_state.dart';


class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  // اسم الـ Box اللي هنخزن فيه الداتا محلياً
  final String _cartBoxName = 'cart_box';

  // 1. تحميل السلة المحفوظة أول ما التطبيق يفتح
  Future<void> loadLocalCart() async {
    var box = await Hive.openBox(_cartBoxName);
    List? savedItems = box.get('items');
    
    if (savedItems != null) {
      // تحويل الداتا المحفوظة لموديلات CartItem
      // (تحتاج لتنفيذ toMap و fromMap في الموديل)
    }
  }

  // 2. إضافة منتج (محلياً)
  void addToCart(ProductModel product) {
    final List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      updatedItems[index].quantity += 1;
    } else {
      updatedItems.add(CartItem(product: product, quantity: 1));
    }
    _updateAndSave(updatedItems);
  }

  // دالة الحفظ والتحديث
  void _updateAndSave(List<CartItem> items) {
    double total = items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    emit(CartState(items: items, totalPrice: total));
    
    // حفظ في Hive هنا لضمان بقاء الداتا
    // var box = Hive.box(_cartBoxName);
    // box.put('items', items.map((e) => e.()).toList());
  }

  // 1. تقليل الكمية (Decrement)
  void removeFromCart(ProductModel product) {
    // بناخد نسخة من القائمة الحالية (Immutable approach)
    final List<CartItem> currentItems = List.from(state.items);
    
    // البحث عن مكان المنتج
    int index = currentItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      if (currentItems[index].quantity > 1) {
        // لو أكتر من قطعة، قلل واحدة
        currentItems[index].quantity -= 1;
      } else {
        // لو هي قطعة واحدة، امسحه خالص من السلة
        currentItems.removeAt(index);
      }
      
      // تحديث الحالة والحفظ المحلي (Hive)
      _updateAndSave(currentItems);
    }
  }

  // 2. مسح المنتج تماماً (Delete) - لزرار السلة الأحمر
  void deleteFromCart(ProductModel product) {
    final List<CartItem> currentItems = List.from(state.items);
    currentItems.removeWhere((item) => item.product.id == product.id);
    
    _updateAndSave(currentItems);
  }



}