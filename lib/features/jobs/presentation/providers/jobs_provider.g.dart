// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeJobsHash() => r'19d0b79a6e5d0ad4ad9b0b1573352866b6c00ab6';

/// See also [activeJobs].
@ProviderFor(activeJobs)
final activeJobsProvider = AutoDisposeStreamProvider<List<JobModel>>.internal(
  activeJobs,
  name: r'activeJobsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeJobsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveJobsRef = AutoDisposeStreamProviderRef<List<JobModel>>;
String _$postJobNotifierHash() => r'f86841213e6f847642f8b91d9c431e5def198583';

/// See also [PostJobNotifier].
@ProviderFor(PostJobNotifier)
final postJobNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PostJobNotifier, void>.internal(
  PostJobNotifier.new,
  name: r'postJobNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postJobNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostJobNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
