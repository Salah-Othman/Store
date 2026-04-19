// import 'package:TR/core/theme/app_theme.dart';
// import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CartItem extends StatelessWidget {
//   final dynamic cartItem; // CartItem model
//   const CartItem({required this.cartItem});

//   @override
//   Widget build(BuildContext context) {
//     final product = cartItem.product;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(product.imageUrl, width: 90, height: 90, fit: BoxFit.cover),
//           ),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(product.name, style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1),
//                 const SizedBox(height: 4),
//                 Text("${product.price} EGP", style: GoogleFonts.manrope(color: AppTheme.secondaryColor, fontWeight: FontWeight.w900)),
//                 const SizedBox(height: 8),
//                 // أزرار التحكم في الكمية
//                 Row(
//                   children: [
//                     _quantityBtn(Icons.remove, () => context.read<CartCubit>().minusFromCart(product)),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text("${cartItem.quantity}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     ),
//                     _quantityBtn(Icons.add, () => context.read<CartCubit>().addToCart(product)),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: () => context.read<CartCubit>().removeFromCart(product),
//             icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _quantityBtn(IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, size: 18, color: AppTheme.primaryColor),
//       ),
//     );
//   }
// }