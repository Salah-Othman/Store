import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/cart/ui/screen/cart_screen.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel product;

  const DetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isDesktop || isTablet
          ? _buildDesktopLayout(context, l10n)
          : _buildMobileLayout(context, l10n),
      bottomSheet: _buildBottomAction(context, isDesktop: isDesktop),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        SizedBox(
          width: context.screenWidth * 0.5,
          child: Image.network(product.imageUrl, fit: BoxFit.cover, height: double.infinity),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                _buildProductInfo(context, isDesktop: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: product.id,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: _buildProductInfo(context, isDesktop: false),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context, {required bool isDesktop}) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: GoogleFonts.notoSerif(
                  fontSize: isDesktop ? 36.sp : 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            Text(
              "${product.price} EGP",
              style: GoogleFonts.manrope(
                fontSize: isDesktop ? 28.sp : 22.sp,
                fontWeight: FontWeight.w900,
                color: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          product.category,
          style: TextStyle(
            color: AppTheme.tertiaryColor,
            fontSize: isDesktop ? 20.sp : 16.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          l10n.description,
          style: GoogleFonts.manrope(
            fontSize: isDesktop ? 22.sp : 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          product.description,
          style: GoogleFonts.manrope(
            fontSize: isDesktop ? 18.sp : 16.sp,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, {required bool isDesktop}) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24.w : 24),
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
            context.read<CartCubit>().addToCart(product);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.addedToCart),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: Size(double.infinity, isDesktop ? 60.h : 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            l10n.addToCart,
            style: GoogleFonts.manrope(
              fontSize: isDesktop ? 22.sp : 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
