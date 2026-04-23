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
  String? _fullAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 400.h,
        child: ListView(
          children: [
            const Text("Saved Address"),
            const SizedBox(height: 12),
            Text(_fullAddress ?? '-'),
          ],
        ),
      ),
    );
  }

  void _loadSavedAddress() {
    final addressBox = Hive.box('settings_box');
    final savedData = addressBox.get('default_address');

    if (savedData == null) return;

    final address = AddressModel.fromMap(Map<String, dynamic>.from(savedData));
    final fullAddress =
        "${address.building}, ${address.street}, ${address.area}, ${address.city}";

    if (!mounted) return;
    setState(() => _fullAddress = fullAddress);
  }
}