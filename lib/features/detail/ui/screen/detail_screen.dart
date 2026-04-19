import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/app_sizes.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/cart/ui/screen/cart_screen.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel product;

  const DetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. الجزء العلوي (الصورة مع تأثير الـ Elastic)
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.id, // لعمل انتقال ناعم بين الصفحات
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          // 2. تفاصيل المنتج
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.notoSerif(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        "${product.price} EGP",
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: AppTheme.tertiaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Description",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100), // مساحة للـ Bottom Bar
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. زر الإضافة للسلة (ثابت في الأسفل)
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // تنفيذ الإضافة للسلة
            context.read<CartCubit>().addToCart(product);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
            // إظهار رسالة تأكيد احترافية (SnackBar)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Added to cart successfully!"),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            "Add to Cart",
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
