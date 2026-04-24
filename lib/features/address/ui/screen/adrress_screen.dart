import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.shippingAddress,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: surfaceColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24.w),
          children: [
            _buildInputLabel(l10n.city, textColor),
            _addressField(_cityController, l10n.cityHint, Icons.location_city, textColor),
            SizedBox(height: 20.h),
            _buildInputLabel(l10n.areaDistrict, textColor),
            _addressField(_areaController, l10n.areaHint, Icons.map_outlined, textColor),
            SizedBox(height: 20.h),
            _buildInputLabel(l10n.streetName, textColor),
            _addressField(_streetController, l10n.streetHint, Icons.streetview, textColor),
            SizedBox(height: 20.h),
            _buildInputLabel(l10n.buildingVilla, textColor),
            _addressField(
              _buildingController,
              l10n.buildingHint,
              Icons.home_work_outlined,
              textColor,
            ),
            SizedBox(height: 50.h),
            ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                l10n.saveAddress,
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
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

  Widget _buildInputLabel(String label, Color textColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
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
    Color textColor,
  ) {
    final l10n = AppLocalizations.of(context);
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.secondaryColor),
        filled: true,
        fillColor: surfaceColor,
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
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.somethingWentWrong),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }
}

