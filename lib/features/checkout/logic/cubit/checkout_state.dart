part of 'checkout_cubit.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {
  final Color surfaceColor;
  final Color textColor;
  final Color primaryColor;

  CheckoutInitial({
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = Colors.blue,
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

class CheckoutLoading extends CheckoutState {}
class CheckoutSuccess extends CheckoutState {
  final String orderId;
  CheckoutSuccess(this.orderId);
}
class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError(this.message);
}