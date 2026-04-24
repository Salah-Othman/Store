import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerBase = Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey[800]! 
        : Colors.grey[300]!;
    final shimmerHighlight = Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey[700]! 
        : Colors.grey[100]!;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: shimmerBase,
      highlightColor: shimmerHighlight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 100.w,
            margin: EdgeInsets.only(right: 12.w),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}