import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call(String email, String password) {
    return _repository.signIn(email, password);
  }
}
