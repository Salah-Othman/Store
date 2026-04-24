import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/cart/model/cart_item_model.dart';
import 'package:TR/features/checkout/ui/screen/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          l10n.cart,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return _buildEmptyState(context);

          if (isDesktop) {
            return _buildDesktopLayout(context, state);
          }
          return _buildMobileLayout(context, state);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, CartState state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: EdgeInsets.all(24.w),
            itemCount: state.items.length,
            itemBuilder: (context, index) =>
                _CartItemTile(item: state.items[index], isDesktop: true),
          ),
        ),
        Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: _buildCheckoutSection(context, state, isDesktop: true),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, CartState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: state.items.length,
            itemBuilder: (context, index) =>
                _CartItemTile(item: state.items[index], isDesktop: false),
          ),
        ),
        _buildCheckoutSection(context, state, isDesktop: false),
      ],
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartState state, {required bool isDesktop}) {
    final l10n = AppLocalizations.of(context);
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24.w : 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: isDesktop ? BorderRadius.zero : BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(context, l10n.totalAmount, "${state.totalPrice} EGP", isTotal: true, isDesktop: isDesktop),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: Size(double.infinity, isDesktop ? 60.h : 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              l10n.goToCheckout,
              style: TextStyle(color: Colors.white, fontSize: isDesktop ? 20.sp : 18.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool isTotal = false, required bool isDesktop}) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: isDesktop ? 18.sp : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: isDesktop ? 24.sp : 20,
            fontWeight: FontWeight.w900,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: textColor),
          SizedBox(height: 16.h),
          Text(
            l10n.yourBagIsEmpty,
            style: TextStyle(color: textColor, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool isDesktop;

  const _CartItemTile({required this.item, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final imageSize = isDesktop ? 100.0 : 70.0;
    final padding = isDesktop ? 16.0 : 12.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 18.sp : null),
                ),
                Text(
                  "${item.product.price} EGP",
                  style: TextStyle(color: AppTheme.secondaryColor, fontSize: isDesktop ? 16.sp : null),
                ),
              ],
            ),
          ),
          _QuantityControls(item: item, isDesktop: isDesktop),
        ],
      ),
    );
  }
}

class _QuantityControls extends StatelessWidget {
  final CartItem item;
  final bool isDesktop;

  const _QuantityControls({required this.item, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final iconSize = isDesktop ? 28.0 : 24.0;
    final iconColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, size: iconSize, color: iconColor),
          onPressed: () =>
              context.read<CartCubit>().removeFromCart(item.product),
        ),
        Text(
          "${item.quantity}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 18.sp : null),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, size: iconSize, color: iconColor),
          onPressed: () => context.read<CartCubit>().addToCart(item.product),
        ),
      ],
    );
  }
}
