import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/sources/auth_remote_source.dart';
import '../../features/auth/data/sources/user_remote_source.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';
import '../../features/auth/domain/usecases/register_alumni_use_case.dart';
import '../../features/auth/domain/usecases/register_student_use_case.dart';
import '../../features/auth/domain/usecases/sign_in_use_case.dart';
import '../../features/auth/domain/usecases/sign_out_use_case.dart';
import '../../features/auth/domain/usecases/watch_auth_state_use_case.dart';

part 'providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@riverpod
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) {
  return FirebaseStorage.instance;
}

@riverpod
IAuthRemoteSource authRemoteSource(AuthRemoteSourceRef ref) {
  return FirebaseAuthRemoteSource(ref.watch(firebaseAuthProvider));
}

@riverpod
IUserRemoteSource userRemoteSource(UserRemoteSourceRef ref) {
  return FirestoreUserRemoteSource(
    ref.watch(firebaseFirestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
}

@riverpod
IAuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    authRemoteSource: ref.watch(authRemoteSourceProvider),
    userRemoteSource: ref.watch(userRemoteSourceProvider),
  );
}

@riverpod
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterStudentUseCase registerStudentUseCase(RegisterStudentUseCaseRef ref) {
  return RegisterStudentUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterAlumniUseCase registerAlumniUseCase(RegisterAlumniUseCaseRef ref) {
  return RegisterAlumniUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
WatchAuthStateUseCase watchAuthStateUseCase(WatchAuthStateUseCaseRef ref) {
  return WatchAuthStateUseCase(ref.watch(authRepositoryProvider));
}
