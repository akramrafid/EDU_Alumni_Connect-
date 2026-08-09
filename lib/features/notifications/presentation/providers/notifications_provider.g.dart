// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userNotificationsHash() => r'ceb48e2aacf38fa6207a3a8ef2f320653a799348';

/// See also [userNotifications].
@ProviderFor(userNotifications)
final userNotificationsProvider =
    AutoDisposeStreamProvider<List<NotificationModel>>.internal(
  userNotifications,
  name: r'userNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserNotificationsRef
    = AutoDisposeStreamProviderRef<List<NotificationModel>>;
String _$unreadNotificationsCountHash() =>
    r'ff0f509b2779c08cc37232a2f36dda584e42e8bf';

/// See also [unreadNotificationsCount].
@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider =
    AutoDisposeStreamProvider<int>.internal(
  unreadNotificationsCount,
  name: r'unreadNotificationsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnreadNotificationsCountRef = AutoDisposeStreamProviderRef<int>;
String _$notificationActionNotifierHash() =>
    r'66fe62576697d721aaaed3c298bb519969c238ab';

/// See also [NotificationActionNotifier].
@ProviderFor(NotificationActionNotifier)
final notificationActionNotifierProvider =
    AutoDisposeAsyncNotifierProvider<NotificationActionNotifier, void>.internal(
  NotificationActionNotifier.new,
  name: r'notificationActionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationActionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationActionNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
