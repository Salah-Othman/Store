import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  
  final _addressBox = Hive.box('settings_box'); // صندوق الإعدادات العامة

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  void _loadSavedAddress() {
    final saved = _addressBox.get('default_address');
    if (saved != null) {
      final address = AddressModel.fromMap(Map<String, dynamic>.from(saved));
      _cityController.text = address.city;
      _areaController.text = address.area;
      _streetController.text = address.street;
      _buildingController.text = address.building;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipping Address", style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildInputLabel("City"),
            _addressField(_cityController, "e.g. Cairo", Icons.location_city),
            const SizedBox(height: 20),
            
            _buildInputLabel("Area / District"),
            _addressField(_areaController, "e.g. New Cairo", Icons.map_outlined),
            const SizedBox(height: 20),
            
            _buildInputLabel("Street Name"),
            _addressField(_streetController, "e.g. 90th Street", Icons.streetview),
            const SizedBox(height: 20),
            
            _buildInputLabel("Building / Villa No."),
            _addressField(_buildingController, "e.g. Building 12, Floor 3", Icons.home_work_outlined),
            
            const SizedBox(height: 50),
            
            ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                "Save Address",
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
      child: Text(label, style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
    );
  }

  Widget _addressField(TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.secondaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (val) => val!.isEmpty ? "Required" : null,
    );
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        city: _cityController.text,
        area: _areaController.text,
        street: _streetController.text,
        building: _buildingController.text,
      );

      await _addressBox.put('default_address', address.toMap());
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address saved successfully"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }
}