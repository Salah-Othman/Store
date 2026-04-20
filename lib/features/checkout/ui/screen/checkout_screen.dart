// presentation/views/checkout_screen.dart
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
  _loadSavedAddress(); // استدعاء دالة التحميل التلقائي
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            // مسح السلة بعد نجاح الأوردر
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
              padding: const EdgeInsets.all(20),
              children: [
                _buildField(_nameController, "Full Name", Icons.person),
                const SizedBox(height: 15),
                _buildField(_phoneController, "Phone Number", Icons.phone, isPhone: true),
                const SizedBox(height: 15),
                _buildField(_addressController, "Detailed Address", Icons.location_on, maxLines: 3),
                const SizedBox(height: 40),
                
                state is CheckoutLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        onPressed: () => _submitOrder(context),
                        child: const Text("Confirm Order", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPhone = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) => val!.isEmpty ? "Required field" : null,
    );
  }

  void _submitOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final cartState = context.read<CartCubit>().state;
      context.read<CheckoutCubit>().placeOrder(
            name: _nameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            cartItems: cartState.items.map((i) => {
              'id': i.product.id,
              'name': i.product.name,
              'price': i.product.price,
              'quantity': i.quantity
            }).toList(),
            total: cartState.totalPrice + 50, // السعر + الشحن
          );
    }
  }

  void _showSuccessDialog(String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Order Placed!"),
        content: Text("Your order ID is: $id\nWe will contact you soon."),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text("Back to Home"))
        ],
      ),
    );
  }

void _loadSavedAddress() {
  // 1. الوصول لصندوق الإعدادات المحفوظة
  final addressBox = Hive.box('settings_box');
  final savedData = addressBox.get('default_address');

  if (savedData != null) {
    // 2. تحويل البيانات من Map لموديل العنوان
    final address = AddressModel.fromMap(Map<String, dynamic>.from(savedData));
    
    // 3. دمج بيانات العنوان في نص واحد وتعيينه لحقل العنوان
    final fullAddress = "${address.building}, ${address.street}, ${address.area}, ${address.city}";
    
    // تأكد من تعيين القيمة للـ Controller
    _addressController.text = fullAddress;
    
    // ملاحظة: يمكنك أيضاً حفظ الاسم ورقم الهاتف في Hive وملئهما بنفس الطريقة
  }
}
}