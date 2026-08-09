// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentorship_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mentorshipRequestsHash() =>
    r'784f11ed5d7909d75540f1e46314a205dbdc5418';

/// See also [mentorshipRequests].
@ProviderFor(mentorshipRequests)
final mentorshipRequestsProvider =
    AutoDisposeStreamProvider<List<MentorshipRequestModel>>.internal(
  mentorshipRequests,
  name: r'mentorshipRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mentorshipRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MentorshipRequestsRef
    = AutoDisposeStreamProviderRef<List<MentorshipRequestModel>>;
String _$mentorshipActionNotifierHash() =>
    r'7ae3f1808bfadbd9ea0496da6222a98750466fb1';

/// See also [MentorshipActionNotifier].
@ProviderFor(MentorshipActionNotifier)
final mentorshipActionNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MentorshipActionNotifier, void>.internal(
  MentorshipActionNotifier.new,
  name: r'mentorshipActionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mentorshipActionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MentorshipActionNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
