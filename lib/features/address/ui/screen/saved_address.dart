import 'package:TR/features/address/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({super.key});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  @override
void initState() {
  super.initState();
  _loadSavedAddress(); // استدعاء دالة التحميل التلقائي
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 400.h,
        child: 
        ListView(
          children: [
            Text("Saved Address"),
          ],
        ),
      ),
    );
  }
  void _loadSavedAddress() {
  // 1. الوصول لصندوق الإعدادات المحفوظة
  final addressBox = Hive.box('settings_box');
  final savedData = addressBox.get('default_address');

  if (savedData != null) {
    // 2. تحويل البيانات من Map لموديل العنوان
    final address = AddressModel.fromMap(Map<String, dynamic>.from(savedData));
    
    // 3. دمج بيانات العنوان في نص واحد وتعيينه لحقل العنوان
    final fullAddress = "${address.building}, ${address.street}, ${address.area}, ${address.city}";
  }
}
}