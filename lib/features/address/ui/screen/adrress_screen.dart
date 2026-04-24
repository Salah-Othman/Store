import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  void _loadSavedAddress() async {
    if (_uid == null) return;
    
    try {
      final doc = await _firestore.collection('users').doc(_uid).get();
      final data = doc.data();
      
      if (data != null && data['addresses'] != null) {
        final addresses = data['addresses'] as List;
        if (addresses.isNotEmpty) {
          final address = Map<String, dynamic>.from(addresses[0] as Map);
          _cityController.text = address['city'] ?? '';
          _areaController.text = address['area'] ?? '';
          _streetController.text = address['street'] ?? '';
          _buildingController.text = address['building'] ?? '';
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.shippingAddress,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildInputLabel(l10n.city),
            _addressField(_cityController, l10n.cityHint, Icons.location_city),
            const SizedBox(height: 20),
            _buildInputLabel(l10n.areaDistrict),
            _addressField(_areaController, l10n.areaHint, Icons.map_outlined),
            const SizedBox(height: 20),
            _buildInputLabel(l10n.streetName),
            _addressField(_streetController, l10n.streetHint, Icons.streetview),
            const SizedBox(height: 20),
            _buildInputLabel(l10n.buildingVilla),
            _addressField(
              _buildingController,
              l10n.buildingHint,
              Icons.home_work_outlined,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                l10n.saveAddress,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _addressField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.secondaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) => val!.isEmpty ? l10n.requiredField : null,
    );
  }

  void _saveAddress() async {
    final l10n = AppLocalizations.of(context);

    if (_formKey.currentState!.validate()) {
      if (_uid == null) return;

      final address = {
        'city': _cityController.text,
        'area': _areaController.text,
        'street': _streetController.text,
        'building': _buildingController.text,
      };

      try {
        await _firestore.collection('users').doc(_uid).set({
          'addresses': FieldValue.arrayUnion([address]),
        }, SetOptions(merge: true));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addressSaved),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.somethingWentWrong),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

