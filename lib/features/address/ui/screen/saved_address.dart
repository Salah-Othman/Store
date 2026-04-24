import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/ui/screen/adrress_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({super.key});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  List<Map<String, dynamic>> _addresses = [];
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = textColor.withValues(alpha: 0.6);

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Address', style: TextStyle(color: textColor)),
        backgroundColor: surfaceColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
            },
            icon: Icon(Icons.add, color: AppTheme.primaryColor, size: 26.sp),
          )
        ],
      ),
      body: SafeArea(
        child: _addresses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off_outlined, size: 80.sp, color: subtitleColor),
                    SizedBox(height: 16.h),
                    Text('No saved addresses', style: TextStyle(color: subtitleColor, fontSize: 18.sp)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final addr = _addresses[index];
                  final fullAddress =
                      "${addr['building']}, ${addr['street']}, ${addr['area']}, ${addr['city']}";
                  return ListTile(
                    leading: Icon(Icons.location_on, color: AppTheme.primaryColor),
                    title: Text(fullAddress, style: TextStyle(color: textColor)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.error),
                      onPressed: () => _deleteAddress(index),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _loadAddresses() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();

      if (data != null && data['addresses'] != null) {
        if (!mounted) return;
        setState(() {
          _addresses = (data['addresses'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        });
      }
    } catch (_) {}
  }

  void _deleteAddress(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestore.collection('users').doc(uid).update({
        'addresses': FieldValue.arrayRemove([_addresses[index]]),
      });
      if (!mounted) return;
      setState(() => _addresses.removeAt(index));
    } catch (_) {}
  }
}