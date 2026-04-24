import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/orders_history/logic/cubit/order_history_cubit.dart';
import 'package:TR/features/orders_history/model/order_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderHistoryCubit>().fetchMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderHistory, style: TextStyle(color: textColor))),
      body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoading) {
            return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }
          if (state is OrderHistoryEmpty) {
            return Center(child: Text(l10n.noOrdersFound, style: TextStyle(color: textColor)));
          }
          if (state is OrderHistoryError) {
            return Center(child: Text(state.message, style: TextStyle(color: textColor)));
          }
          if (state is OrderHistoryLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.orders.length,
              itemBuilder: (context, index) =>
                  _orderCard(order: state.orders[index]),
            );
          }
          return Center(child: Text(l10n.somethingWentWrong, style: TextStyle(color: textColor)));
        },
      ),
    );
  }

  Widget _orderCard({required OrderModel order}) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final localeName = Localizations.localeOf(context).languageCode;
        final surfaceColor = Theme.of(context).colorScheme.surface;
        final textColor = Theme.of(context).colorScheme.onSurface;
        final subtitleColor = textColor.withValues(alpha: 0.6);

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.orderNumber(order.id.substring(0, 8)),
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                  ),
                  _buildStatusBadge(context, order.status),
                ],
              ),
              Divider(height: 24.h),
              Text(
                l10n.itemsCount(order.items.length),
                style: TextStyle(color: subtitleColor),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat(
                      'dd MMM yyyy, hh:mm a',
                      localeName,
                    ).format(order.createdAt),
                    style: TextStyle(fontSize: 12.sp, color: subtitleColor),
                  ),
                  Text(
                    "${order.totalPrice} EGP",
                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    var color = Colors.orange;
    if (status == 'Delivered') color = Colors.green;
    if (status == 'Shipped') color = Colors.blue;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        l10n.localizedOrderStatus(status),
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
