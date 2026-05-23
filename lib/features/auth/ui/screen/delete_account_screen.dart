import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/auth/logic/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final hintColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          l10n.deleteAccount,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAccountDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.deleteAccountSuccess)),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 72.sp,
                  color: AppTheme.error,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                l10n.deleteAccountWarning,
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  color: hintColor,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                l10n.permanentActionWarning,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.error,
                ),
              ),
              SizedBox(height: 40.h),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.manrope(fontSize: 16.sp, color: textColor),
                decoration: InputDecoration(
                  labelText: l10n.currentPassword,
                  labelStyle: GoogleFonts.manrope(fontSize: 14.sp, color: hintColor),
                  prefixIcon: Icon(Icons.lock_outline, size: 22),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error,
                      minimumSize: Size(double.infinity, 56.h),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22.sp,
                            height: 22.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.deleteAccount,
                            style: GoogleFonts.manrope(
                              fontSize: 16.sp,
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
    );
  }

  void _submit() {
    context.read<AuthCubit>().deleteAccount(
      password: _passwordController.text,
    );
  }
}
