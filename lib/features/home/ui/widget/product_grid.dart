import 'package:TR/core/widgets/product_card.dart';
import 'package:TR/features/detail/ui/screen/detail_screen.dart';
import 'package:TR/features/home/logic/products/products_cubit.dart';
import 'package:TR/features/home/logic/products/products_state.dart';
import 'package:TR/features/home/ui/widget/product_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const ProductGridShimmer();
        } else if (state is ProductsLoaded) {
          final products = state.products;
          return SliverPadding(
            padding: EdgeInsets.all(8.w),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(product: product),));
                  },
                  child: ProductCard(product: product));
              }, childCount: products.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
            ),
          );
        } else if (state is ProductsError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Error: ${state.message}')),
          );
        } else if (state is ProductsEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text(state.message)),
          );
        }
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox.shrink(),
        );
      },
    );
  }
}
