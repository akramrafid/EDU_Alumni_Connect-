import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyState({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  // Factory constructors
  factory EmptyState.noResults({
    Key? key,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return EmptyState(
      key: key,
      icon: const Icon(Icons.search_off, size: 64, color: Colors.grey),
      title: 'No Results Found', // TODO: l10n
      subtitle: subtitle ?? 'We couldn\'t find what you were looking for. Try adjusting your filters.', // TODO: l10n
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  factory EmptyState.noConnections({
    Key? key,
    VoidCallback? onActionPressed,
  }) {
    return EmptyState(
      key: key,
      icon: const Icon(Icons.people_outline, size: 64, color: Colors.grey),
      title: 'No Connections', // TODO: l10n
      subtitle: 'Build your network by connecting with alumni and students.', // TODO: l10n
      actionLabel: 'Browse Directory', // TODO: l10n
      onActionPressed: onActionPressed,
    );
  }

  factory EmptyState.noMessages({
    Key? key,
    VoidCallback? onActionPressed,
  }) {
    return EmptyState(
      key: key,
      icon: const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
      title: 'No Messages', // TODO: l10n
      subtitle: 'Start a conversation with mentors or peers in the directory.', // TODO: l10n
      actionLabel: 'Find Someone', // TODO: l10n
      onActionPressed: onActionPressed,
    );
  }

  factory EmptyState.noEvents({
    Key? key,
    VoidCallback? onActionPressed,
  }) {
    return EmptyState(
      key: key,
      icon: const Icon(Icons.event_busy, size: 64, color: Colors.grey),
      title: 'No Events', // TODO: l10n
      subtitle: 'There are no upcoming events at the moment. Check back later!', // TODO: l10n
      actionLabel: 'Refresh', // TODO: l10n
      onActionPressed: onActionPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Semantics(
                label: 'Empty state illustration', // TODO: l10n
                child: icon!,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: actionLabel!,
                onPressed: onActionPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
