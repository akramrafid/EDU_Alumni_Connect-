import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../core/di/providers.dart';
import '../providers/auth_provider.dart';

class VerificationPendingScreen extends ConsumerWidget {
  const VerificationPendingScreen({super.key});

  Future<void> _refreshStatus(BuildContext context, WidgetRef ref) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // 1. Reload Firebase user to fetch updated custom claims and tokens
      final auth = ref.read(firebaseAuthProvider);
      final user = auth.currentUser;
      if (user != null) {
        await user.reload();
        // Force refresh ID token to sync claims
        await user.getIdToken(true);
      }

      // 2. Invalidate the Riverpod authStateProvider to force reloading user metadata from Firestore
      ref.invalidate(authStateProvider);
      
      // Wait for provider to reload
      final updatedUser = await ref.read(authStateProvider.future);

      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog

        if (updatedUser != null && updatedUser.isVerifiedAlumni) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account verified successfully! Welcome to EDU Alumni Connect.'), // TODO: l10n
              backgroundColor: AppColors.matcha,
            ),
          );
          context.go(AppRoutes.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification still in progress. Please check back later.'), // TODO: l10n
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to check status: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final signOut = ref.read(signOutUseCaseProvider);
    final result = await signOut();
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (_) {
        ref.invalidate(authStateProvider);
        context.go(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pending Illustration Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.mulledWine.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pending_actions_outlined,
                  color: AppColors.mulledWine,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                'Verification in Progress', // TODO: l10n
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Detail Card
              AppCard(
                child: Column(
                  children: [
                    const Text(
                      'An administrator is currently reviewing your graduation documents. This security protocol prevents spoofing and keeps the student network safe.', // TODO: l10n
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Estimated time: 24 to 48 hours.', // TODO: l10n
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mulledWine,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Refresh CTA
                    AppButton(
                      label: 'Refresh Status', // TODO: l10n
                      isFullWidth: true,
                      onPressed: () => _refreshStatus(context, ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Log out text link
              TextButton(
                onPressed: () => _signOut(context, ref),
                child: const Text(
                  'Sign Out', // TODO: l10n
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
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
