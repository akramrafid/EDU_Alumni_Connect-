// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'd0465cf0c57a578814458f6b73702781c13fcec8';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<AuthUser?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateRef = AutoDisposeStreamProviderRef<AuthUser?>;
String _$currentUserHash() => r'4b318c678013b167254643d9b39ad17673cfd7de';

/// See also [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeNotifierProvider<CurrentUser, AsyncValue<AuthUser?>>.internal(
  CurrentUser.new,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUser = AutoDisposeNotifier<AsyncValue<AuthUser?>>;
String _$signInNotifierHash() => r'dc4536336b679f6d0c26f8430a5f20a21404fc3d';

/// See also [SignInNotifier].
@ProviderFor(SignInNotifier)
final signInNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SignInNotifier, void>.internal(
  SignInNotifier.new,
  name: r'signInNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignInNotifier = AutoDisposeAsyncNotifier<void>;
String _$registerNotifierHash() => r'59b3a1ea5e614fa2fefc6270a8983cac8fb791e9';

/// See also [RegisterNotifier].
@ProviderFor(RegisterNotifier)
final registerNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RegisterNotifier, void>.internal(
  RegisterNotifier.new,
  name: r'registerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$registerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RegisterNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
