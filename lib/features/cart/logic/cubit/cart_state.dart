part of 'cart_cubit.dart';

class CartState {
  final List<CartItem> items;
  final double totalPrice;
  final bool isDesktop;
  final bool isDarkMode;
  final Color scaffoldBg;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryColor;
  final Color btnColor;

  const CartState({
    required this.items,
    required this.totalPrice,
    this.isDesktop = false,
    this.isDarkMode = false,
    this.scaffoldBg = Colors.white,
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.secondaryColor = AppTheme.secondaryColor,
    this.btnColor = AppTheme.secondaryColor,
  });

  factory CartState.initial() => const CartState(items: [], totalPrice: 0.0);

  CartState copyWith({
    List<CartItem>? items,
    double? totalPrice,
    bool? isDesktop,
    bool? isDarkMode,
    Color? scaffoldBg,
    Color? surfaceColor,
    Color? textColor,
    Color? secondaryColor,
    Color? btnColor,
  }) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      isDesktop: isDesktop ?? this.isDesktop,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      btnColor: btnColor ?? this.btnColor,
    );
  }
}