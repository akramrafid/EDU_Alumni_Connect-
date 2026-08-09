import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.mulledWine,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Dismissible(
                key: Key(notif.notificationId),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref
                      .read(notificationActionNotifierProvider.notifier)
                      .delete(notif.notificationId);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: notif.read ? Colors.white : const Color(0xFFFDEAEA),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.mulledWine.withOpacity(0.1),
                      child: Icon(
                        _getIconForType(notif.type),
                        color: AppColors.mulledWine,
                      ),
                    ),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight:
                            notif.read ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notif.body),
                    onTap: () {
                      if (!notif.read) {
                        ref
                            .read(notificationActionNotifierProvider.notifier)
                            .markAsRead(notif.notificationId);
                      }
                      if (notif.payload.route.isNotEmpty) {
                        context.push(notif.payload.route);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'mentorship_request':
      case 'mentorship_accepted':
      case 'mentorship_declined':
        return Icons.handshake_outlined;
      case 'new_message':
        return Icons.chat_bubble_outline;
      case 'event_reminder':
        return Icons.event;
      case 'job_posted':
        return Icons.work_outline;
      default:
        return Icons.notifications_none;
    }
  }
}
