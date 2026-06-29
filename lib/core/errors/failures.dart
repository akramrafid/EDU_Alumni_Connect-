import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({
    required String message,
    Object? cause,
  }) = NetworkFailure;

  const factory Failure.auth({
    required String message,
    Object? cause,
  }) = AuthFailure;

  const factory Failure.validation({
    required String message,
    Object? cause,
  }) = ValidationFailure;

  const factory Failure.notFound({
    required String message,
    Object? cause,
  }) = NotFoundFailure;

  const factory Failure.permission({
    required String message,
    Object? cause,
  }) = PermissionFailure;

  const factory Failure.server({
    required String message,
    Object? cause,
  }) = ServerFailure;

  const factory Failure.cache({
    required String message,
    Object? cause,
  }) = CacheFailure;

  const factory Failure.unknown({
    required String message,
    Object? cause,
  }) = UnknownFailure;
}
