// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$upcomingEventsHash() => r'5eb5a532c8093f5fb6fd88d40a465699a85f4ddb';

/// See also [upcomingEvents].
@ProviderFor(upcomingEvents)
final upcomingEventsProvider =
    AutoDisposeStreamProvider<List<EventModel>>.internal(
  upcomingEvents,
  name: r'upcomingEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpcomingEventsRef = AutoDisposeStreamProviderRef<List<EventModel>>;
String _$rsvpNotifierHash() => r'2d579ce0fd729ecd0d06f49bf89ae1a21399f469';

/// See also [RsvpNotifier].
@ProviderFor(RsvpNotifier)
final rsvpNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RsvpNotifier, void>.internal(
  RsvpNotifier.new,
  name: r'rsvpNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rsvpNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RsvpNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
