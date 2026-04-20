import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/app_sizes.dart';
import 'package:TR/core/utils/app_strings.dart';
import 'package:TR/core/widgets/category_item.dart';
import 'package:TR/features/cart/ui/screen/cart_screen.dart';
import 'package:TR/features/home/logic/category/category_cubit.dart';
import 'package:TR/features/home/logic/products/products_cubit.dart';
import 'package:TR/features/home/ui/widget/bannar_widget.dart';
import 'package:TR/features/home/ui/widget/product_grid.dart';
import 'package:TR/features/profile/ui/screen/profile_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu, color: AppTheme.primaryColor, size: 30),
        title: Padding(

          padding:  EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            AppStrings.appName,
            style: Theme.of(
              context,
            ).textTheme.displayLarge!.copyWith(color: AppTheme.tertiaryColor),
          ),
        ),
        // centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_bag, color: AppTheme.primaryColor, size: 30),
                  onPressed: () {
                    // Handle search action
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: AppTheme.primaryColor, size: 30),
                  onPressed: () {
                    // Handle search action
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                ),
              ],
            ),
            //ProfileScreen
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryCubit>().getCategories();
          context.read<ProductsCubit>().getAllProducts();
        },
        child: CustomScrollView(
          slivers: [
            // 1. عنوان الترحيب
             SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p8),
                child: BannarWidget(),
              ),
            ),

            // 2. قسم التصنيفات (Horizontal)
             SliverToBoxAdapter(
              child: 
              CategoryItem(

              ),
            ),

            // 3. مساحة فاصلة
             SliverToBoxAdapter(child: SizedBox(height: 10.h)),

            // 4. شبكة المنتجات (Grid)
             ProductGrid(),
          ],
        ),
      ),
    );
  }
}
