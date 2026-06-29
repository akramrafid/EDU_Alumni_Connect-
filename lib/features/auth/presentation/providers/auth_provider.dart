import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<AuthUser?> authState(AuthStateRef ref) {
  // TODO: Implement real auth state stream from FirebaseAuth remote source in Phase 1
  return Stream.value(null);
}

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  AsyncValue<AuthUser?> build() {
    return ref.watch(authStateProvider);
  }
}
