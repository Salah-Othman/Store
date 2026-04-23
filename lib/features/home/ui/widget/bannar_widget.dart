import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannarWidget extends StatelessWidget {
  const BannarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p8.w),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('banners')
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          final bannerDoc = snapshot.data?.docs.isNotEmpty == true
              ? snapshot.data!.docs.first
              : null;
          final imageUrl = bannerDoc?.data()['imageUrl']?.toString();

          return Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:
                    (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/images/app_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}