import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_spacing.dart';
import 'app_card.dart';

class LoadingShimmer extends StatelessWidget {
  final Widget child;

  const LoadingShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use shades of our Mulled Wine / warm background palette
    final baseColor = isDark ? const Color(0xFF381A21) : const Color(0xFFF2ECE8);
    final highlightColor = isDark ? const Color(0xFF4C2A31) : const Color(0xFFF9F6F4);

    return ExcludeSemantics(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      ),
    );
  }

  static Widget block({double width = double.infinity, double height = 16, double borderRadius = AppRadius.xs}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ShimmerAvatar extends StatelessWidget {
  final double size;

  const ShimmerAvatar({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const ShimmerCard({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: AppCard(
        color: Colors.white,
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const ShimmerAvatar(size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer.block(height: 14, width: 120),
                      const SizedBox(height: AppSpacing.sm),
                      LoadingShimmer.block(height: 10, width: 80),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            LoadingShimmer.block(height: 12, width: double.infinity),
            const SizedBox(height: AppSpacing.sm),
            LoadingShimmer.block(height: 12, width: 180),
          ],
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.lg,
        ),
        child: Row(
          children: [
            const ShimmerAvatar(size: 48),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingShimmer.block(height: 14, width: 140),
                  const SizedBox(height: AppSpacing.sm),
                  LoadingShimmer.block(height: 10, width: double.infinity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
