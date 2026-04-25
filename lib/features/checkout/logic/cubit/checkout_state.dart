part of 'checkout_cubit.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {
  final Color surfaceColor;
  final Color textColor;
  final Color primaryColor;

  CheckoutInitial({
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = const Color(0xFF2196F3),
  });

  CheckoutInitial copyWith({
    Color? surfaceColor,
    Color? textColor,
    Color? primaryColor,
  }) {
    return CheckoutInitial(
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}

class CheckoutLoading extends CheckoutState {
  final Color surfaceColor;
  final Color textColor;
  final Color primaryColor;

  CheckoutLoading({
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = const Color(0xFF2196F3),
  });
}

class CheckoutSuccess extends CheckoutState {
  final String orderId;
  final Color surfaceColor;
  final Color textColor;
  final Color primaryColor;

  CheckoutSuccess(this.orderId, {
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = const Color(0xFF2196F3),
  });
}

class CheckoutError extends CheckoutState {
  final String message;
  final Color surfaceColor;
  final Color textColor;
  final Color primaryColor;

  CheckoutError(this.message, {
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = const Color(0xFF2196F3),
  });
}