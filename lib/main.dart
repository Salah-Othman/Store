import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/auth/logic/cubit/auth_cubit.dart';
import 'package:TR/features/cart/logic/cubit/cart_cubit.dart';
import 'package:TR/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:TR/features/home/logic/category/category_cubit.dart';
import 'package:TR/features/home/logic/products/products_cubit.dart';
import 'package:TR/features/orders_history/logic/cubit/order_history_cubit.dart';
import 'package:TR/firebase_options.dart';
import 'package:TR/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox('cart_box');
  await Hive.openBox('settings_box');
  await Hive.openBox('orders_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings_box');
    return ScreenUtilInit(
      designSize: const Size(360, 813),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthCubit()),
            BlocProvider(create: (_) => CategoryCubit()),
            BlocProvider(create: (_) => ProductsCubit()),
            BlocProvider(create: (_) => CartCubit()..init()),
            BlocProvider(create: (_) => CheckoutCubit()),
            BlocProvider(create: (_) => OrderHistoryCubit()),
          ],
          child: ValueListenableBuilder(
            valueListenable: settingsBox.listenable(
              keys: ['isDarkMode', 'appLanguage'],
            ),
            builder: (context, box, _) {
              final isDarkMode =
                  box.get('isDarkMode', defaultValue: false) as bool;
              final languageCode =
                  box.get('appLanguage', defaultValue: 'en') as String;

              return MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                locale: Locale(languageCode),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                home: const SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}