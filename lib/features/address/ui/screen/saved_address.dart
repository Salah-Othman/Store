import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/model/address_model.dart';
import 'package:TR/features/address/ui/screen/adrress_screen.dart';
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
      appBar: AppBar(
        title: Text('Saved Address',
        
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressScreen()));
          }, icon: Icon(Icons.add, color: AppTheme.primaryColor, size: 26,))
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: 400.h,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_fullAddress ?? 'No Address Add'),
              ),
            ],
          ),
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