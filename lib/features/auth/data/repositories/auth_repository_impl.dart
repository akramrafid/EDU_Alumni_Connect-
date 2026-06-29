import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/user_model.dart';
import '../sources/auth_remote_source.dart';
import '../sources/user_remote_source.dart';

/*
 * EXPECTED CLOUD FUNCTION GATEWAY SPECIFICATION:
 *
 * approveAlumni(uid)
 * - Description: Admin-only function to approve a pending alumni registration.
 * - Actions:
 *   1. Verifies the caller is an Authenticated Admin (has `role: admin` in their custom claims).
 *   2. Sets the custom claims on the target user's token: `{role: 'alumni'}`.
 *   3. Updates the target user's document in Firestore (`/users/{uid}`) to:
 *      `{ verificationStatus: 'verified', updatedAt: FieldValue.serverTimestamp() }`.
 *   4. Creates a public searchable profile entry in `/alumniDirectory/{uid}`:
 *      `{ uid, fullName, department, batchYear, currentCompany, jobTitle, verified: true, ... }`.
 *   5. Dispatches an FCM push notification notifying the target alumni of approval.
 * - Usage in Flutter:
 *   await FirebaseFunctions.instance.httpsCallable('approveAlumni').call({'uid': uid});
 */

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteSource _authRemoteSource;
  final IUserRemoteSource _userRemoteSource;

  AuthRepositoryImpl({
    required IAuthRemoteSource authRemoteSource,
    required IUserRemoteSource userRemoteSource,
  })  : _authRemoteSource = authRemoteSource,
        _userRemoteSource = userRemoteSource;

  @override
  Future<Either<Failure, AuthUser>> signIn(String email, String password) async {
    return TaskEither<Failure, AuthUser>(() async {
      try {
        final credential = await _authRemoteSource.signInWithEmail(email, password);
        final user = credential.user;
        if (user == null) {
          return left(const Failure.auth(message: 'Sign in failed: User is null'));
        }

        final userDoc = await _userRemoteSource.getUserDocument(user.uid);
        if (userDoc == null) {
          return left(const Failure.notFound(message: 'User profile document not found.'));
        }

        return right(userDoc.toEntity(isEmailVerified: user.emailVerified));
      } on fb.FirebaseAuthException catch (e) {
        return left(_mapAuthException(e));
      } catch (e) {
        return left(Failure.unknown(message: e.toString()));
      }
    }).run();
  }

  @override
  Future<Either<Failure, AuthUser>> registerStudent({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
  }) async {
    return TaskEither<Failure, AuthUser>(() async {
      try {
        // Enforce university email in repository domain check
        if (!email.toLowerCase().endsWith('@eastdelta.edu.bd')) {
          return left(const Failure.validation(
            message: 'Registration requires an East Delta University email address (@eastdelta.edu.bd).',
          ));
        }

        final credential = await _authRemoteSource.registerWithEmail(email, password);
        final user = credential.user;
        if (user == null) {
          return left(const Failure.auth(message: 'Registration failed: User is null'));
        }

        // Student document initialization
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          fullName: fullName,
          role: UserRole.student,
          verificationStatus: VerificationStatus.verified, // Auto-verified via email domain
          department: department,
          batchYear: batchYear,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRemoteSource.createUserDocument(userModel);
        await _authRemoteSource.sendVerificationEmail();

        return right(userModel.toEntity(isEmailVerified: user.emailVerified));
      } on fb.FirebaseAuthException catch (e) {
        return left(_mapAuthException(e));
      } catch (e) {
        return left(Failure.unknown(message: e.toString()));
      }
    }).run();
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
    return TaskEither<Failure, AuthUser>(() async {
      try {
        final credential = await _authRemoteSource.registerWithEmail(email, password);
        final user = credential.user;
        if (user == null) {
          return left(const Failure.auth(message: 'Registration failed: User is null'));
        }

        // Upload degree certificate to Storage
        final File certFile = File(certificatePath);
        final certUrl = await _userRemoteSource.uploadCertificate(user.uid, certFile);

        // Alumni starts as pending verification
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          fullName: fullName,
          role: UserRole.alumni,
          verificationStatus: VerificationStatus.pending,
          department: department,
          batchYear: batchYear,
          currentCompany: currentCompany,
          jobTitle: jobTitle,
          certificateUrl: certUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRemoteSource.createUserDocument(userModel);
        await _authRemoteSource.sendVerificationEmail();

        return right(userModel.toEntity(isEmailVerified: user.emailVerified));
      } on fb.FirebaseAuthException catch (e) {
        return left(_mapAuthException(e));
      } catch (e) {
        return left(Failure.unknown(message: e.toString()));
      }
    }).run();
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    return TaskEither<Failure, Unit>(() async {
      try {
        await _authRemoteSource.signOut();
        return right(unit);
      } catch (e) {
        return left(Failure.unknown(message: e.toString()));
      }
    }).run();
  }

  @override
  Stream<Either<Failure, AuthUser?>> authStateChanges() {
    return _authRemoteSource.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return right(null);
      }
      try {
        final userDoc = await _userRemoteSource.getUserDocument(user.uid);
        if (userDoc == null) {
          return left(const Failure.notFound(message: 'User profile document not found.'));
        }
        return right(userDoc.toEntity(isEmailVerified: user.emailVerified));
      } catch (e) {
        return left(Failure.unknown(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUserClaims() async {
    return TaskEither<Failure, Map<String, dynamic>>(() async {
      try {
        final user = _authRemoteSource.getCurrentUser();
        if (user == null) {
          return left(const Failure.auth(message: 'No logged in user found.'));
        }
        final tokenResult = await _authRemoteSource.getIdTokenResult(user);
        final claims = tokenResult?.claims ?? {};
        return right(claims);
      } catch (e) {
        return left(Failure.unknown(message: e.toString()));
      }
    }).run();
  }

  Failure _mapAuthException(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const Failure.auth(message: 'The email address is invalid.');
      case 'user-disabled':
        return const Failure.auth(message: 'This user account has been disabled.');
      case 'user-not-found':
        return const Failure.notFound(message: 'No user account found with this email.');
      case 'wrong-password':
        return const Failure.auth(message: 'Incorrect password. Please try again.');
      case 'email-already-in-use':
        return const Failure.auth(message: 'An account already exists with this email.');
      case 'weak-password':
        return const Failure.auth(message: 'The password provided is too weak.');
      case 'operation-not-allowed':
        return const Failure.permission(message: 'Authentication method not enabled.');
      case 'requires-recent-login':
        return const Failure.permission(message: 'Security sensitive action requires logging in again.');
      default:
        return Failure.auth(message: e.message ?? 'An unknown authentication error occurred.');
    }
  }
}
