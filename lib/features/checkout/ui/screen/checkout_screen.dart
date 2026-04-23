import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/model/address_model.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/checkout/logic/cubit/cheackout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
                _buildField(
                  _addressController,
                  l10n.detailedAddress,
                  Icons.location_on,
                  maxLines: 3,
                ),
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
      context.read<CheckoutCubit>().placeOrder(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
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
        total: cartState.totalPrice + 50,
      );
    }
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

  void _loadSavedAddress() {
    final addressBox = Hive.box('settings_box');
    final savedData = addressBox.get('default_address');

    if (savedData != null) {
      final address = AddressModel.fromMap(
        Map<String, dynamic>.from(savedData),
      );
      final fullAddress =
          "${address.building}, ${address.street}, ${address.area}, ${address.city}";
      _addressController.text = fullAddress;
    }
  }
}
