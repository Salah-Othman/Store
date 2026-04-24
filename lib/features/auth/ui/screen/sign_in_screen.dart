import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/auth/logic/cubit/auth_cubit.dart';
import 'package:TR/features/auth/ui/screen/forgot_password_screen.dart';
import 'package:TR/features/auth/ui/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final maxWidth = isDesktop ? 450.0 : (isTablet ? 500.0 : double.infinity);

    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 32.w : 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isDesktop ? 60.h : 80.h),
                      Text(
                        l10n.signInTitle,
                        style: GoogleFonts.notoSerif(
                          fontSize: isDesktop ? 36.sp : 30.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.signInSubtitle,
                        style: GoogleFonts.manrope(
                          fontSize: isDesktop ? 18.sp : 15.sp,
                          color: AppTheme.tertiaryColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 48.h : 32.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.manrope(fontSize: isDesktop ? 18.sp : 16.sp),
                        decoration: InputDecoration(
                          labelText: l10n.emailAddress,
                          labelStyle: GoogleFonts.manrope(fontSize: isDesktop ? 16.sp : 14.sp),
                          prefixIcon: Icon(Icons.email_outlined, size: isDesktop ? 26.sp : 22),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? l10n.emailRequired
                            : null,
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.manrope(fontSize: isDesktop ? 18.sp : 16.sp),
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          labelStyle: GoogleFonts.manrope(fontSize: isDesktop ? 16.sp : 14.sp),
                          prefixIcon: Icon(Icons.lock_outline, size: isDesktop ? 26.sp : 22),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: isDesktop ? 26.sp : 22,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? l10n.passwordRequired
                            : null,
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            l10n.forgotPassword,
                            style: GoogleFonts.manrope(fontSize: isDesktop ? 16.sp : 14.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().signIn(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, isDesktop ? 64.h : 56),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: isDesktop ? 28.sp : 22,
                                    height: isDesktop ? 28.sp : 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: isDesktop ? 3 : 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    l10n.signIn,
                                    style: GoogleFonts.manrope(
                                      fontSize: isDesktop ? 20.sp : 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.dontHaveAccount,
                            style: GoogleFonts.manrope(fontSize: isDesktop ? 16.sp : 14.sp),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              l10n.signUp,
                              style: GoogleFonts.manrope(
                                fontSize: isDesktop ? 16.sp : 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
