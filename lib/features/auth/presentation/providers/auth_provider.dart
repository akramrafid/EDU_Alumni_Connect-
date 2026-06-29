import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/providers.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<AuthUser?> authState(AuthStateRef ref) {
  final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);
  return watchAuthState().map((either) => either.fold(
        (failure) => throw failure,
        (user) => user,
      ));
}

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  AsyncValue<AuthUser?> build() {
    return ref.watch(authStateProvider);
  }
}

@riverpod
class SignInNotifier extends _$SignInNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    final signIn = ref.read(signInUseCaseProvider);
    final result = await signIn(email, password);

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> registerStudent({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
  }) async {
    state = const AsyncLoading();
    final register = ref.read(registerStudentUseCaseProvider);
    final result = await register(
      email: email,
      password: password,
      fullName: fullName,
      department: department,
      batchYear: batchYear,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }

  Future<bool> registerAlumni({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
    String? currentCompany,
    String? jobTitle,
    required String certificatePath,
  }) async {
    state = const AsyncLoading();
    final register = ref.read(registerAlumniUseCaseProvider);
    final result = await register(
      email: email,
      password: password,
      fullName: fullName,
      department: department,
      batchYear: batchYear,
      currentCompany: currentCompany,
      jobTitle: jobTitle,
      certificatePath: certificatePath,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}
