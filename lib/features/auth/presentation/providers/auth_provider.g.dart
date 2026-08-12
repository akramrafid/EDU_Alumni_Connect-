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
String _$userProfileStreamHash() => r'd1134502e1175d68a72e380a12a0b1fb44637167';

/// See also [userProfileStream].
@ProviderFor(userProfileStream)
final userProfileStreamProvider = AutoDisposeStreamProvider<AuthUser?>.internal(
  userProfileStream,
  name: r'userProfileStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserProfileStreamRef = AutoDisposeStreamProviderRef<AuthUser?>;
String _$currentUserHash() => r'91c35042e28884b6785a732466c4f9bb291b4e90';

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
