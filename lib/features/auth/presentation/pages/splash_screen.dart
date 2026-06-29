import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/university_crest.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/auth_user.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
    _navigateToNext();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    // Wait for the minimum duration of 1.8 seconds (1.0s fade + 0.8s hold)
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

      if (!mounted) return;

      final authStateAsync = ref.read(currentUserProvider);

      authStateAsync.when(
        data: (user) {
          if (!mounted) return;
          if (user == null) {
            if (onboardingSeen) {
              context.go(AppRoutes.login);
            } else {
              context.go(AppRoutes.onboarding);
            }
          } else {
            if (user.role == UserRole.alumni &&
                user.verificationStatus == VerificationStatus.pending) {
              context.go('/pending');
            } else {
              context.go(AppRoutes.home);
            }
          }
        },
        error: (_, __) {
          if (!mounted) return;
          context.go(AppRoutes.login);
        },
        loading: () {
          // Retry check after a short delay if state is still loading
          Future.delayed(const Duration(milliseconds: 500), _navigateToNext);
        },
      );
    } catch (_) {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.mulledWine,
              AppColors.backgroundDark,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const UniversityCrest(size: 140, color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  'EDU Alumni', // TODO: l10n
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.matcha,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display',
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Connect', // TODO: l10n
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
