import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/ui/screen/adrress_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Address'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
            },
            icon: Icon(Icons.add, color: AppTheme.primaryColor, size: 26),
          )
        ],
      ),
      body: SafeArea(
        child: _addresses.isEmpty
            ? Center(child: Text('No saved addresses'))
            : ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final addr = _addresses[index];
                  final fullAddress =
                      "${addr['building']}, ${addr['street']}, ${addr['area']}, ${addr['city']}";
                  return ListTile(
                    leading: Icon(Icons.location_on, color: AppTheme.primaryColor),
                    title: Text(fullAddress),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
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