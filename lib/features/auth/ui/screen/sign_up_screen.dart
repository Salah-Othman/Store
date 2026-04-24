import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/auth/logic/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;
    final maxWidth = isDesktop ? 450.0 : double.infinity;

    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      appBar: AppBar(
        title: Text(
          l10n.createAccount,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }

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
                      SizedBox(height: isDesktop ? 40.h : 20.h),
                      Text(
                        l10n.createAccount,
                        style: GoogleFonts.notoSerif(
                          fontSize: isDesktop ? 36.sp : 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.signUpSubtitle,
                        style: GoogleFonts.manrope(
                          fontSize: isDesktop ? 18.sp : 15.sp,
                          color: AppTheme.tertiaryColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 40.h : 28.h),
                      TextFormField(
                        controller: _nameController,
                        style: GoogleFonts.manrope(fontSize: isDesktop ? 18.sp : 16.sp),
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
                          labelStyle: GoogleFonts.manrope(fontSize: isDesktop ? 16.sp : 14.sp),
                          prefixIcon: Icon(Icons.person_outline, size: isDesktop ? 26.sp : 22),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? l10n.nameRequired
                            : null,
                      ),
                      SizedBox(height: 16.h),
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
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.manrope(fontSize: isDesktop ? 18.sp : 16.sp),
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumber,
                          hintText: l10n.phoneNumberHint,
                          labelStyle: GoogleFonts.manrope(fontSize: isDesktop ? 16.sp : 14.sp),
                          prefixIcon: Icon(Icons.phone_outlined, size: isDesktop ? 26.sp : 22),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? l10n.phoneRequired
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
                        validator: (value) =>
                            value == null || value.trim().length < 6
                            ? l10n.passwordMinLength
                            : null,
                      ),
                      SizedBox(height: 24.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().signUp(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        phoneNumber: _phoneController.text,
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
                                    l10n.signUp,
                                    style: GoogleFonts.manrope(
                                      fontSize: isDesktop ? 20.sp : 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
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
