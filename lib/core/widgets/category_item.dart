import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/app_sizes.dart';
import 'package:TR/core/widgets/category_shimmer.dart';
import 'package:TR/features/home/logic/category/category_cubit.dart';
import 'package:TR/features/home/logic/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  // "All" هو الاختيار الافتراضي عند فتح التطبيق
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) return const CategoryShimmer();
          
          if (state is CategoryLoaded) {
            
            final List<String> categories = ["All", ...state.categories.map((e) => e.name)];

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final categoryName = categories[index];
                final isSelected = selectedCategory == categoryName;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categoryName;
                    });
                    // نداء الـ Cubit لفلترة المنتجات
                    context.read<ProductsCubit>().getProductsByCategory(categoryName);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(25), // تصميم Round للأناقة
                      border: Border.all(
                        color: isSelected ? AppTheme.secondaryColor : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: GoogleFonts.manrope(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppTheme.tertiaryColor,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}