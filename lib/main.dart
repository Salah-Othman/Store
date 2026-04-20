import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/checkout/logic/cubit/cheackout_cubit.dart';
import 'package:TR/features/home/logic/category/category_cubit.dart';
import 'package:TR/features/home/logic/products/products_cubit.dart';
import 'package:TR/features/home/ui/screen/home_screen.dart';
import 'package:TR/features/orders_history/logic/cubit/order_history_cubit.dart';
import 'package:TR/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // 1. تأكيد تهيئة كل الـ Widgets قبل أي شيء
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تهيئة Firebase باستخدام الـ Options الخاصة بمشروعك
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. تهيئة Hive للتخزين المحلي (للسلة بدون Auth)
  await Hive.initFlutter();
  await Hive.openBox('cart_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 813),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CategoryCubit()),
            BlocProvider(create: (_) => ProductsCubit()),
            BlocProvider(create: (_) => CartCubit()),
            BlocProvider(create: (_) => CheckoutCubit()),
            BlocProvider(create: (_) => OrderHistoryCubit()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
        );
      },
    );
  }
}
