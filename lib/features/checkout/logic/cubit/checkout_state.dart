part of 'checkout_cubit.dart';

abstract class CheckoutState {
  final Color surfaceColor;
  final Color textColor;
  final Color primaryColor;

  const CheckoutState({
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = const Color(0xFF2196F3),
  });
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial({
    super.surfaceColor,
    super.textColor,
    super.primaryColor,
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
  const CheckoutLoading({
    super.surfaceColor,
    super.textColor,
    super.primaryColor,
  });
}

class CheckoutSuccess extends CheckoutState {
  final String orderId;

  const CheckoutSuccess(this.orderId, {
    super.surfaceColor,
    super.textColor,
    super.primaryColor,
  });
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message, {
    super.surfaceColor,
    super.textColor,
    super.primaryColor,
  });
}