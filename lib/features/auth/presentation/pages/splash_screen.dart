import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
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
      if (!mounted) return;

      final authStateAsync = ref.read(currentUserProvider);

      authStateAsync.when(
        data: (user) {
          if (!mounted) return;
          if (user == null) {
            context.go(AppRoutes.onboarding);
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
      backgroundColor: AppColors.mulledWine,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'EDU Alumni\nConnect', // TODO: l10n
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
