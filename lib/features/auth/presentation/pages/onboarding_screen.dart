import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_seen', true);
    } catch (_) {}
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPageData(
        title: 'Connect with Alumni', // TODO: l10n
        subtitle: 'Find and interact with East Delta University alumni from CSE, EEE, BBA, and more.', // TODO: l10n
        badge1: '100+ Alumni', // TODO: l10n
        badge2: 'Verified Mentors', // TODO: l10n
        badge1Top: 40.0,
        badge1Right: 10.0,
        badge2Bottom: 30.0,
        badge2Left: 10.0,
      ),
      _OnboardingPageData(
        title: 'Find a Mentor', // TODO: l10n
        subtitle: 'Request structured mentorship and receive professional career advice directly from graduates.', // TODO: l10n
        badge1: 'Guidance', // TODO: l10n
        badge2: 'Grow Faster', // TODO: l10n
        badge1Top: 20.0,
        badge1Left: 20.0,
        badge2Bottom: 40.0,
        badge2Right: 20.0,
      ),
      _OnboardingPageData(
        title: 'Grow Together', // TODO: l10n
        subtitle: 'Stay updated on campus events, RSVP, and discover career opportunities shared by your network.', // TODO: l10n
        badge1: 'Post Jobs', // TODO: l10n
        badge2: 'Attend Events', // TODO: l10n
        badge1Top: 30.0,
        badge1Right: 30.0,
        badge2Bottom: 20.0,
        badge2Left: 30.0,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'Skip', // TODO: l10n
                    style: TextStyle(
                      color: AppColors.textSecondaryDark.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            // Onboarding Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => _currentPageNotifier.value = index,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),

            // Navigation Bottom Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: _currentPageNotifier,
                builder: (context, currentPage, child) {
                  final isLastPage = currentPage == pages.length - 1;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => _buildIndicator(index == currentPage),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // CTA Button
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: isLastPage
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 48), // Spacer balance
                            TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'Next', // TODO: l10n
                                    style: TextStyle(
                                      color: AppColors.matcha,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.xs),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.matcha,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        secondChild: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _completeOnboarding,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.matcha,
                              foregroundColor: AppColors.onAccentDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                            ),
                            child: const Text(
                              'Get Started', // TODO: l10n
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPageData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const Spacer(),
          // Center 3D graphic with floating badges
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glassy sphere asset
                Image.asset(
                  'assets/images/onboarding_sphere.png',
                  height: 240,
                  width: 240,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.matcha.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.diversity_3,
                      size: 64,
                      color: AppColors.matcha,
                    ),
                  ),
                ),
                
                // Floating Badge 1
                Positioned(
                  top: data.badge1Top,
                  left: data.badge1Left,
                  right: data.badge1Right,
                  bottom: data.badge1Bottom,
                  child: _GlassmorphicBadge(label: data.badge1),
                ),

                // Floating Badge 2
                Positioned(
                  top: data.badge2Top,
                  left: data.badge2Left,
                  right: data.badge2Right,
                  bottom: data.badge2Bottom,
                  child: _GlassmorphicBadge(label: data.badge2),
                ),
              ],
            ),
          ),
          const Spacer(),
          
          // Texts
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Playfair Display',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondaryDark,
              height: 1.5,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.matcha : AppColors.textSecondaryDark.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final String badge1;
  final String badge2;
  final double? badge1Top;
  final double? badge1Left;
  final double? badge1Right;
  final double? badge1Bottom;
  final double? badge2Top;
  final double? badge2Left;
  final double? badge2Right;
  final double? badge2Bottom;

  _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.badge1,
    required this.badge2,
    this.badge1Top,
    this.badge1Left,
    this.badge1Right,
    this.badge1Bottom,
    this.badge2Top,
    this.badge2Left,
    this.badge2Right,
    this.badge2Bottom,
  });
}

class _GlassmorphicBadge extends StatelessWidget {
  final String label;

  const _GlassmorphicBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
