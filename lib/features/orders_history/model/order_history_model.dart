import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final List<dynamic> items;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      items: data['items'] ?? [],
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}