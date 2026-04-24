import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  List<Map<String, dynamic>> _savedAddresses = [];
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkout)),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            context.read<CartCubit>().clearCart();
            _showSuccessDialog(state.orderId);
          }
          if (state is CheckoutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildField(_nameController, l10n.fullName, Icons.person),
                const SizedBox(height: 15),
                _buildField(
                  _phoneController,
                  l10n.phoneNumber,
                  Icons.phone,
                  isPhone: true,
                ),
                const SizedBox(height: 15),
                Text(l10n.shippingAddress,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedAddress,
                        hint: Text(l10n.shippingAddress),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: [
                          ..._savedAddresses.map((addr) {
                            final fullAddr = _formatAddress(addr);
                            return DropdownMenuItem(
                              value: fullAddr,
                              child: Text(fullAddr,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  
                                  ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAddress = value;
                            _showNewAddressForm = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showNewAddressForm = !_showNewAddressForm;
                          _selectedAddress = null;
                        });
                      },
                      icon: Icon(
                        _showNewAddressForm
                            ? Icons.keyboard_arrow_up
                            : Icons.add_location_alt,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                if (_showNewAddressForm) ...[
                  const SizedBox(height: 15),
                  _buildField(_cityController, l10n.city, Icons.location_city),
                  const SizedBox(height: 12),
                  _buildField(_areaController, l10n.areaDistrict, Icons.map),
                  const SizedBox(height: 12),
                  _buildField(_streetController, l10n.streetName, Icons.streetview),
                  const SizedBox(height: 12),
                  _buildField(
                      _buildingController, l10n.buildingVilla, Icons.home),
                ],
                const SizedBox(height: 40),
                state is CheckoutLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        onPressed: () => _submitOrder(context),
                        child: Text(
                          l10n.confirmOrder,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPhone = false,
    int maxLines = 1,
  }) {
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).requiredField)),
          );
          return;
        }
        _saveNewAddress();
      } else if (_selectedAddress != null) {
        address = _selectedAddress!;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).requiredField)),
        );
        return;
      }
      
      context.read<CheckoutCubit>().placeOrder(
        name: _nameController.text,
        phone: _phoneController.text,
        address: address,
        cartItems: cartState.items
            .map(
              (i) => {
                'id': i.product.id,
                'name': i.product.name,
                'price': i.product.price,
                'quantity': i.quantity,
              },
            )
            .toList(),
        total: cartState.totalPrice + 25,
      );
    }
  }

  void _saveNewAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final address = {
      'city': _cityController.text,
      'area': _areaController.text,
      'street': _streetController.text,
      'building': _buildingController.text,
    };

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'addresses': FieldValue.arrayUnion([address]),
      }, SetOptions(merge: true));
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
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).popUntil((route) => route.isFirst),
            child: Text(l10n.backToHome),
          ),
        ],
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
        _savedAddresses = (data['addresses'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        if (_savedAddresses.isNotEmpty && _selectedAddress == null) {
          _selectedAddress = _formatAddress(_savedAddresses.first);
          _addressController.text = _selectedAddress!;
        }
      }
    } catch (_) {}
  }

  String _formatAddress(Map<String, dynamic> address) {
    return "${address['building']}, ${address['street']}, ${address['area']}, ${address['city']}";
  }

  void _onAddressSelected(String? fullAddress) {
    setState(() {
      _selectedAddress = fullAddress;
      _addressController.text = fullAddress ?? '';
    });
  }

  Future<void> _prefillUserData() async {
    if (_didPrefillUserData) return;
    _didPrefillUserData = true;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) return;

      final name = data['name']?.toString().trim();
      final phone = data['phoneNumber']?.toString().trim();

      if (!mounted) return;

      // Only prefill if user hasn't typed yet.
      if ((_nameController.text).trim().isEmpty &&
          name != null &&
          name.isNotEmpty) {
        _nameController.text = name;
      }
      if ((_phoneController.text).trim().isEmpty &&
          phone != null &&
          phone.isNotEmpty) {
        _phoneController.text = phone;
      }
    } catch (_) {
      // If Firestore fails, just keep fields empty for manual entry.
    }
  }
}
