import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/university_crest.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(signInNotifierProvider.notifier).signIn(
            _emailController.text,
            _passwordController.text,
          );
      if (success && mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to authentication errors to display SnackBars
    ref.listen<AsyncValue<void>>(
      signInNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, _) {
            // Strip structural Exception tags if they exist
            final errorMessage = error.toString().replaceFirst('Exception: ', '');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
      },
    );

    final signInState = ref.watch(signInNotifierProvider);
    final isLoading = signInState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular University Logo
              const UniversityCrest(
                size: 100,
                color: AppColors.mulledWine,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Styled App Name
              Text(
                'EDU Alumni Connect', // TODO: l10n
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Login Input Container
              AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome Back', // TODO: l10n
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Email input
                      AppTextField(
                        controller: _emailController,
                        label: 'University Email', // TODO: l10n
                        hint: 'username@eastdelta.edu.bd', // TODO: l10n
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email'; // TODO: l10n
                          }
                          final email = value.trim();
                          if (!email.contains('@') || !email.endsWith('.edu.bd')) {
                            return 'Please enter a valid university email'; // TODO: l10n
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password input
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password', // TODO: l10n
                        hint: '••••••••', // TODO: l10n
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'; // TODO: l10n
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters'; // TODO: l10n
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  // Placeholder for password reset feature
                                },
                          child: const Text(
                            'Forgot Password?', // TODO: l10n
                            style: TextStyle(
                              color: AppColors.mulledWine,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Submit button
                      AppButton(
                        label: 'Sign In', // TODO: l10n
                        onPressed: _submit,
                        isLoading: isLoading,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Decorative visual divider
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Text(
                              'or', // TODO: l10n
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Link to registration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "New here?", // TODO: l10n
                            style: TextStyle(color: AppColors.textSecondaryLight),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => context.push(AppRoutes.register),
                            child: const Text(
                              'Create Account', // TODO: l10n
                              style: TextStyle(
                                color: AppColors.mulledWine,
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
            ],
          ),
        ),
      ),
    );
  }
}
