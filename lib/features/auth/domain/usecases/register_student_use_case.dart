import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class RegisterStudentUseCase {
  final IAuthRepository _repository;

  RegisterStudentUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
    required String fullName,
    required String department,
    required int batchYear,
  }) {
    return _repository.registerStudent(
      email: email,
      password: password,
      fullName: fullName,
      department: department,
      batchYear: batchYear,
    );
  }
}
