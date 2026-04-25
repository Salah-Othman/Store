import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/home/model/product_model.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final ProductModel product;

  DetailCubit({required this.product}) : super(const DetailState());

  void init(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final theme = Theme.of(context);
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final subtitleColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final surfaceColor = theme.colorScheme.surface;
    final btnTheme = theme.elevatedButtonTheme;
    final btnColor = btnTheme.style?.backgroundColor?.resolve({});

    emit(state.copyWith(
      isDesktop: isDesktop,
      isTablet: isTablet,
      scaffoldBg: scaffoldBg,
      textColor: textColor,
      subtitleColor: subtitleColor,
      surfaceColor: surfaceColor,
      btnColor: btnColor,
    ));
  }

  void addToCart(BuildContext context) {
    context.read<CartCubit>().addToCart(product);
    emit(state.copyWith(addedToCart: true));
  }

  void resetAddedToCart() {
    emit(state.copyWith(addedToCart: false));
  }
}