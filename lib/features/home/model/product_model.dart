class ProductModel {
  final String id;          // معرف المنتج في Firestore
  final String name;        // اسم المنتج
  final String description; // الوصف
  final double price;       // السعر
  final String imageUrl;    // رابط الصورة من Firebase Storage
  final String category;    // التصنيف (Clothes, Food, etc.)
  final bool isAvailable;   // هل متاح في المخزن؟

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
  });

// From Firestore
  factory ProductModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return ProductModel(
      id: documentId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // بنعمل cast للسعر عشان نضمن إنه double حتى لو جاي من Firebase كـ int
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'General',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  // To Map (for local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  // From Map (for local storage)
  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'General',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}