import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<dynamic> items;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    final createdAtValue = data['createdAt'];

    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      items: data['items'] ?? [],
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      customerAddress: data['customerAddress'] ?? '',
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
