import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthUser>> signIn(String email, String password);
  
  Future<Either<Failure, AuthUser>> registerStudent({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
  });
  
  Future<Either<Failure, AuthUser>> registerAlumni({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
    String? currentCompany,
    String? jobTitle,
    required String certificatePath,
  });
  
  Future<Either<Failure, Unit>> signOut();
  
  Stream<Either<Failure, AuthUser?>> authStateChanges();
  
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUserClaims();
}
