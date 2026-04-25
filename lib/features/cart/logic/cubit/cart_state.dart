part of 'cart_cubit.dart';


class CartState {
  final List<CartItem> items;
  final double totalPrice;
  final bool isDesktop;
  final Color scaffoldBg;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryColor;
  final Color btnColor;

  CartState({
    required this.items,
    required this.totalPrice,
    this.isDesktop = false,
    this.scaffoldBg = Colors.white,
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.secondaryColor = const Color(0xFFFF6B00),
    this.btnColor = const Color(0xFFFF6B00),
  });

  factory CartState.initial() => CartState(items: [], totalPrice: 0.0);

  CartState copyWith({
    List<CartItem>? items,
    double? totalPrice,
    bool? isDesktop,
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
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      btnColor: btnColor ?? this.btnColor,
    );
  }
}