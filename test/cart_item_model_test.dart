import 'package:flutter_test/flutter_test.dart';
import 'package:TR/features/cart/model/cart_item_model.dart';
import 'package:TR/features/home/model/product_model.dart';

void main() {
  group('CartItem', () {
    final testProduct = ProductModel(
      id: 'product-1',
      name: 'Test Product',
      description: 'Description',
      price: 50.0,
      imageUrl: 'https://example.com/image.jpg',
      category: 'Test',
    );

    test('creates CartItem with default quantity of 1', () {
      final item = CartItem(product: testProduct);

      expect(item.product, testProduct);
      expect(item.quantity, 1);
    });

    test('creates CartItem with custom quantity', () {
      final item = CartItem(product: testProduct, quantity: 3);

      expect(item.product, testProduct);
      expect(item.quantity, 3);
    });

    group('copyWith', () {
      test('creates copy with updated quantity', () {
        final item = CartItem(product: testProduct, quantity: 1);
        final updated = item.copyWith(quantity: 5);

        expect(updated.product, testProduct);
        expect(updated.quantity, 5);
      });

      test('creates copy with updated product', () {
        final item = CartItem(product: testProduct, quantity: 1);
        final newProduct = ProductModel(
          id: 'product-2',
          name: 'New Product',
          description: 'New Description',
          price: 100.0,
          imageUrl: 'https://example.com/new.jpg',
          category: 'New',
        );
        final updated = item.copyWith(product: newProduct);

        expect(updated.product, newProduct);
        expect(updated.quantity, 1);
      });

      test('creates copy preserving original when no changes', () {
        final item = CartItem(product: testProduct, quantity: 2);
        final updated = item.copyWith();

        expect(updated.product, item.product);
        expect(updated.quantity, item.quantity);
      });
    });

    group('toMap', () {
      test('converts CartItem to Map', () {
        final item = CartItem(product: testProduct, quantity: 3);
        final map = item.toMap();

        expect(map['quantity'], 3);
        expect(map['product'], isA<Map<String, dynamic>>());
        expect(map['product']['id'], 'product-1');
        expect(map['product']['name'], 'Test Product');
      });
    });

    group('fromMap', () {
      test('creates CartItem from Map', () {
        final map = {
          'product': {
            'id': 'product-1',
            'name': 'Test Product',
            'description': 'Description',
            'price': 50.0,
            'imageUrl': 'https://example.com/image.jpg',
            'category': 'Test',
            'isAvailable': true,
          },
          'quantity': 3,
        };

        final item = CartItem.fromMap(map);

        expect(item.product.id, 'product-1');
        expect(item.product.name, 'Test Product');
        expect(item.quantity, 3);
      });

      test('defaults to quantity 1 when missing', () {
        final map = {
          'product': {
            'id': 'product-1',
            'name': 'Test Product',
            'description': 'Description',
            'price': 50.0,
            'imageUrl': 'https://example.com/image.jpg',
            'category': 'Test',
            'isAvailable': true,
          },
        };

        final item = CartItem.fromMap(map);

        expect(item.quantity, 1);
      });
    });

    group('roundtrip serialization', () {
      test('toMap and fromMap preserve data', () {
        final item = CartItem(product: testProduct, quantity: 5);
        final map = item.toMap();
        final restored = CartItem.fromMap(map);

        expect(restored.product.id, item.product.id);
        expect(restored.product.name, item.product.name);
        expect(restored.quantity, item.quantity);
      });
    });
  });
}