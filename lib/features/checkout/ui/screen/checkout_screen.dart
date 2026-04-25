import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  bool _didPrefillUserData = false;
  final List<Map<String, dynamic>> _savedAddresses = [];
  String? _selectedAddress;
  bool _showNewAddressForm = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
    _prefillUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CheckoutCubit>().initTheme(context);
    final l10n = AppLocalizations.of(context);
    final state = context.watch<CheckoutCubit>().state;
    
    final surfaceColor = _getThemeColor(state, (s) => s.surfaceColor);
    final textColor = _getThemeColor(state, (s) => s.textColor);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout, style: TextStyle(color: textColor)),
        backgroundColor: surfaceColor,
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            context.read<CartCubit>().clearCart();
            _showSuccessDialog(state.orderId);
          }
          if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                _buildField(_nameController, l10n.fullName, Icons.person, textColor: textColor),
                SizedBox(height: 15.h),
                _buildField(_phoneController, l10n.phoneNumber, Icons.phone, isPhone: true, textColor: textColor),
                SizedBox(height: 15.h),
                Text(l10n.shippingAddress, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: textColor)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedAddress,
                        hint: Text(l10n.shippingAddress, style: TextStyle(color: textColor)),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on, color: textColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _savedAddresses.map((addr) {
                          final fullAddr = _formatAddress(addr);
                          return DropdownMenuItem(value: fullAddr, child: Text(fullAddr, overflow: TextOverflow.ellipsis, maxLines: 2));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAddress = value;
                            _showNewAddressForm = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showNewAddressForm = !_showNewAddressForm;
                          _selectedAddress = null;
                        });
                      },
                      icon: Icon(_showNewAddressForm ? Icons.keyboard_arrow_up : Icons.add_location_alt, color: textColor, size: 30.sp),
                    ),
                  ],
                ),
                if (_showNewAddressForm) ...[
                  SizedBox(height: 15.h),
                  _buildField(_cityController, l10n.city, Icons.location_city, textColor: textColor),
                  SizedBox(height: 12.h),
                  _buildField(_areaController, l10n.areaDistrict, Icons.map, textColor: textColor),
                  SizedBox(height: 12.h),
                  _buildField(_streetController, l10n.streetName, Icons.streetview, textColor: textColor),
                  SizedBox(height: 12.h),
                  _buildField(_buildingController, l10n.buildingVilla, Icons.home, textColor: textColor),
                ],
                SizedBox(height: 40.h),
                state is CheckoutLoading
                    ? Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, minimumSize: Size(double.infinity, 55.h)),
                        onPressed: () => _submitOrder(context),
                        child: Text(l10n.confirmOrder, style: TextStyle(color: Colors.white, fontSize: 18.sp)),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPhone = false, int maxLines = 1, required Color textColor}) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: textColor), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (val) => val!.isEmpty ? l10n.requiredField : null,
    );
  }

  void _submitOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final cartState = context.read<CartCubit>().state;
      String address = '';
      if (_showNewAddressForm) {
        address = "${_buildingController.text}, ${_streetController.text}, ${_areaController.text}, ${_cityController.text}";
        if (address == ', , , ') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).requiredField)));
          return;
        }
        _saveNewAddress();
      } else if (_selectedAddress != null) {
        address = _selectedAddress!;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).requiredField)));
        return;
      }
      context.read<CheckoutCubit>().placeOrder(name: _nameController.text, phone: _phoneController.text, address: address, cartItems: cartState.items.map((i) => {'id': i.product.id, 'name': i.product.name, 'price': i.product.price, 'quantity': i.quantity}).toList(), total: cartState.totalPrice + 25);
    }
  }

  void _saveNewAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final address = {'city': _cityController.text, 'area': _areaController.text, 'street': _streetController.text, 'building': _buildingController.text};
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({'addresses': FieldValue.arrayUnion([address])}, SetOptions(merge: true));
    } catch (_) {}
  }

  void _showSuccessDialog(String id) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.orderPlaced),
        content: Text(l10n.orderPlacedMessage(id)),
        actions: [TextButton(onPressed: () => Navigator.of(dialogContext).popUntil((route) => route.isFirst), child: Text(l10n.backToHome))],
      ),
    );
  }

  void _loadSavedAddresses() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && data['addresses'] != null) {
        _savedAddresses.addAll((data['addresses'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
        if (_savedAddresses.isNotEmpty && _selectedAddress == null) {
          _selectedAddress = _formatAddress(_savedAddresses.first);
          _addressController.text = _selectedAddress!;
        }
      }
    } catch (_) {}
  }

  String _formatAddress(Map<String, dynamic> address) => "${address['building']}, ${address['street']}, ${address['area']}, ${address['city']}";

  Future<void> _prefillUserData() async {
    if (_didPrefillUserData) return;
    _didPrefillUserData = true;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) return;
      final name = data['name']?.toString().trim();
      final phone = data['phoneNumber']?.toString().trim();
      if (!mounted) return;
      if (_nameController.text.trim().isEmpty && name != null && name.isNotEmpty) _nameController.text = name;
      if (_phoneController.text.trim().isEmpty && phone != null && phone.isNotEmpty) _phoneController.text = phone;
    } catch (_) {}
  }

  Color _getThemeColor(CheckoutState state, Color Function(dynamic s) getter) {
    if (state is CheckoutInitial) return getter(state);
    if (state is CheckoutLoading) return getter(state);
    if (state is CheckoutSuccess) return getter(state);
    if (state is CheckoutError) return getter(state);
    return Colors.white;
  }
}