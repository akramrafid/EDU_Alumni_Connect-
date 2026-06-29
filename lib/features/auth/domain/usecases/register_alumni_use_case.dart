import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class RegisterAlumniUseCase {
  final IAuthRepository _repository;

  RegisterAlumniUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
    String? currentCompany,
    String? jobTitle,
    required String certificatePath,
  }) {
    return _repository.registerAlumni(
      email: email,
      password: password,
      fullName: fullName,
      department: department,
      batchYear: batchYear,
      currentCompany: currentCompany,
      jobTitle: jobTitle,
      certificatePath: certificatePath,
    );
  }
}
