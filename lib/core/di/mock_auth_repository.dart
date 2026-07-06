import 'dart:async';
import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';
import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';

/// A mock repository that accepts any credentials and returns dummy
/// AuthUser objects so the full UI flow can be exercised without Firebase.
class MockAuthRepository implements IAuthRepository {
  // Singleton to ensure the same stream controller is shared
  static final MockAuthRepository _instance = MockAuthRepository._internal();
  factory MockAuthRepository() => _instance;
  MockAuthRepository._internal();

  AuthUser? _currentUser;
  final StreamController<Either<Failure, AuthUser?>> _authController =
      StreamController<Either<Failure, AuthUser?>>.broadcast();

  @override
  Future<Either<Failure, AuthUser>> signIn(String email, String password) async {
    // Accept any non-empty email/password combination
    await Future.delayed(const Duration(milliseconds: 300));
    final user = AuthUser(
      uid: 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      role: UserRole.student,
      verificationStatus: VerificationStatus.verified,
      fullName: email.split('@').first,
      isEmailVerified: true,
    );
    _currentUser = user;
    _authController.add(right(user));
    return right(user);
  }

  @override
  Future<Either<Failure, AuthUser>> registerStudent({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = AuthUser(
      uid: 'mock_student_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      role: UserRole.student,
      verificationStatus: VerificationStatus.verified,
      fullName: fullName,
      isEmailVerified: false, // Simulates needing email verification
    );
    _currentUser = user;
    _authController.add(right(user));
    return right(user);
  }

  @override
  Future<Either<Failure, AuthUser>> registerAlumni({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
    String? currentCompany,
    String? jobTitle,
    required String certificatePath,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = AuthUser(
      uid: 'mock_alumni_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      role: UserRole.alumni,
      verificationStatus: VerificationStatus.pending,
      fullName: fullName,
      isEmailVerified: false,
    );
    _currentUser = user;
    _authController.add(right(user));
    return right(user);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    _currentUser = null;
    _authController.add(right(null));
    return right(unit);
  }

  @override
  Stream<Either<Failure, AuthUser?>> authStateChanges() async* {
    // Emit current state immediately so splash screen can proceed
    yield right<Failure, AuthUser?>(_currentUser);
    // Then forward all future sign-in/sign-out events
    yield* _authController.stream;
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUserClaims() async {
    if (_currentUser == null) {
      return left(const Failure.auth(message: 'No logged in user found.'));
    }
    return right({'role': _currentUser!.role.name});
  }
}
