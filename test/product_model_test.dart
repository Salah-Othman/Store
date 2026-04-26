import 'package:flutter_test/flutter_test.dart';
import 'package:TR/features/home/model/product_model.dart';

void main() {
  group('ProductModel', () {
    final testProduct = ProductModel(
      id: 'test-id',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
      category: 'Test Category',
      isAvailable: true,
    );

    group('fromFirestore', () {
      test('creates ProductModel from Firestore data', () {
        final json = {
          'name': 'Test Product',
          'description': 'Test Description',
          'price': 99.99,
          'imageUrl': 'https://example.com/image.jpg',
          'category': 'Test Category',
          'isAvailable': true,
        };

        final product = ProductModel.fromFirestore(json, 'doc-id');

        expect(product.id, 'doc-id');
        expect(product.name, 'Test Product');
        expect(product.description, 'Test Description');
        expect(product.price, 99.99);
        expect(product.imageUrl, 'https://example.com/image.jpg');
        expect(product.category, 'Test Category');
        expect(product.isAvailable, true);
      });

      test('handles missing fields with defaults', () {
        final json = <String, dynamic>{};
        final product = ProductModel.fromFirestore(json, 'doc-id');

        expect(product.id, 'doc-id');
        expect(product.name, '');
        expect(product.description, '');
        expect(product.price, 0.0);
        expect(product.imageUrl, '');
        expect(product.category, 'General');
        expect(product.isAvailable, true);
      });

      test('converts int price to double', () {
        final json = {
          'name': 'Test',
          'price': 100,
        };

        final product = ProductModel.fromFirestore(json, 'doc-id');

        expect(product.price, 100.0);
        expect(product.price, isA<double>());
      });
    });

    group('toMap', () {
      test('converts ProductModel to Map', () {
        final map = testProduct.toMap();

        expect(map['id'], 'test-id');
        expect(map['name'], 'Test Product');
        expect(map['description'], 'Test Description');
        expect(map['price'], 99.99);
        expect(map['imageUrl'], 'https://example.com/image.jpg');
        expect(map['category'], 'Test Category');
        expect(map['isAvailable'], true);
      });
    });

    group('fromMap', () {
      test('creates ProductModel from Map', () {
        final map = {
          'id': 'test-id',
          'name': 'Test Product',
          'description': 'Test Description',
          'price': 99.99,
          'imageUrl': 'https://example.com/image.jpg',
          'category': 'Test Category',
          'isAvailable': true,
        };

        final product = ProductModel.fromMap(map);

        expect(product.id, 'test-id');
        expect(product.name, 'Test Product');
        expect(product.description, 'Test Description');
        expect(product.price, 99.99);
        expect(product.imageUrl, 'https://example.com/image.jpg');
        expect(product.category, 'Test Category');
        expect(product.isAvailable, true);
      });

      test('handles missing fields with defaults', () {
        final map = <String, dynamic>{};

        final product = ProductModel.fromMap(map);

        expect(product.id, '');
        expect(product.name, '');
        expect(product.description, '');
        expect(product.price, 0.0);
        expect(product.imageUrl, '');
        expect(product.category, 'General');
        expect(product.isAvailable, true);
      });
    });

    group('roundtrip serialization', () {
      test('toMap and fromMap preserve data', () {
        final map = testProduct.toMap();
        final restored = ProductModel.fromMap(map);

        expect(restored.id, testProduct.id);
        expect(restored.name, testProduct.name);
        expect(restored.description, testProduct.description);
        expect(restored.price, testProduct.price);
        expect(restored.imageUrl, testProduct.imageUrl);
        expect(restored.category, testProduct.category);
        expect(restored.isAvailable, testProduct.isAvailable);
      });
    });
  });
}