part of 'detail_cubit.dart';

class DetailState {
  final bool isDesktop;
  final bool isTablet;
  final Color scaffoldBg;
  final Color textColor;
  final Color subtitleColor;
  final Color surfaceColor;
  final Color? btnColor;
  final bool addedToCart;

  const DetailState({
    this.isDesktop = false,
    this.isTablet = false,
    this.scaffoldBg = Colors.white,
    this.textColor = Colors.black,
    this.subtitleColor = Colors.grey,
    this.surfaceColor = Colors.white,
    this.btnColor,
    this.addedToCart = false,
  });

  DetailState copyWith({
    bool? isDesktop,
    bool? isTablet,
    Color? scaffoldBg,
    Color? textColor,
    Color? subtitleColor,
    Color? surfaceColor,
    Color? btnColor,
    bool? addedToCart,
  }) {
    return DetailState(
      isDesktop: isDesktop ?? this.isDesktop,
      isTablet: isTablet ?? this.isTablet,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      textColor: textColor ?? this.textColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      btnColor: btnColor ?? this.btnColor,
      addedToCart: addedToCart ?? this.addedToCart,
    );
  }
}