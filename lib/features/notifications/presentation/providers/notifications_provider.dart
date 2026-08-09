import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/notification_model.dart';

part 'notifications_provider.g.dart';

@riverpod
Stream<List<NotificationModel>> userNotifications(UserNotificationsRef ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.watchNotifications(user.uid).map(
        (either) => either.fold(
          (failure) => <NotificationModel>[],
          (notifs) => notifs,
        ),
      );
}

@riverpod
Stream<int> unreadNotificationsCount(UnreadNotificationsCountRef ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(0);
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.watchUnreadCount(user.uid).map(
        (either) => either.fold(
          (failure) => 0,
          (count) => count,
        ),
      );
}

@riverpod
class NotificationActionNotifier extends _$NotificationActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> markAsRead(String notificationId) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(uid: user.uid, notificationId: notificationId);
  }

  Future<void> delete(String notificationId) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    final repo = ref.read(notificationRepositoryProvider);
    await repo.deleteNotification(uid: user.uid, notificationId: notificationId);
  }
}
