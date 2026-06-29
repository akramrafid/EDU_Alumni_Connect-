import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class WatchAuthStateUseCase {
  final IAuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<Either<Failure, AuthUser?>> call() {
    return _repository.authStateChanges();
  }
}
