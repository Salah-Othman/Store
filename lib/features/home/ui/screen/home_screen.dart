import 'package:TR/core/utils/app_sizes.dart';
import 'package:TR/core/utils/app_strings.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/core/widgets/category_item.dart';
import 'package:TR/features/home/logic/category/category_cubit.dart';
import 'package:TR/features/home/logic/products/products_cubit.dart';
import 'package:TR/features/home/ui/widget/bannar_widget.dart';
import 'package:TR/features/home/ui/widget/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getCategories();
    context.read<ProductsCubit>().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16.w : 12.w),
          child: Text(
            AppStrings.appName,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: isDesktop ? 28.sp : 22.sp,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryCubit>().getCategories();
          context.read<ProductsCubit>().getAllProducts();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 16.w : AppSizes.p8),
                child: isDesktop
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: context.screenWidth * 0.8),
                        child: BannarWidget(),
                      )
                    : BannarWidget(),
              ),
            ),
            SliverToBoxAdapter(child: CategoryItem()),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ProductGrid(),
          ],
        ),
      ),
    );
  }
}
