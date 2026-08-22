import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/di/providers.dart';
import '../../data/models/user_model.dart';
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
Stream<AuthUser?> userProfileStream(UserProfileStreamRef ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value(null);

  if (AppConfig.useMock) {
    return Stream.value(authUser);
  }

  try {
    final firestore = ref.watch(firebaseFirestoreProvider);
    return firestore.collection('users').doc(authUser.uid).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return authUser;
      try {
        final model = UserModel.fromFirestore(data, doc.id);
        return model.toEntity(isEmailVerified: authUser.isEmailVerified);
      } catch (_) {
        return authUser;
      }
    }).handleError((_) => authUser);
  } catch (_) {
    return Stream.value(authUser);
  }
}

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  AsyncValue<AuthUser?> build() {
    final streamUser = ref.watch(userProfileStreamProvider);
    if (streamUser.hasValue && streamUser.value != null) {
      return streamUser;
    }
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
        state = AsyncError(failure, StackTrace.empty);
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
        state = AsyncError(failure, StackTrace.empty);
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
        state = AsyncError(failure, StackTrace.empty);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}
