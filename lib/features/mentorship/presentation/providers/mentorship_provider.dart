import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/mentorship_request_model.dart';

part 'mentorship_provider.g.dart';

@riverpod
Stream<List<MentorshipRequestModel>> mentorshipRequests(
    MentorshipRequestsRef ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);
  final repo = ref.watch(mentorshipRepositoryProvider);

  if (user.role.name == 'student') {
    return repo.watchStudentRequests(user.uid).map(
          (either) => either.fold(
            (failure) => <MentorshipRequestModel>[],
            (requests) => requests,
          ),
        );
  } else {
    return repo.watchAlumniRequests(user.uid).map(
          (either) => either.fold(
            (failure) => <MentorshipRequestModel>[],
            (requests) => requests,
          ),
        );
  }
}

@riverpod
class MentorshipActionNotifier extends _$MentorshipActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> sendRequest({
    required String alumniId,
    required String message,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(mentorshipRepositoryProvider);
    final result = await repo.sendRequest(
      alumniId: alumniId,
      message: message,
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

  Future<bool> respond({
    required String requestId,
    required String action,
    String? reason,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(mentorshipRepositoryProvider);
    final result = await repo.respondToRequest(
      requestId: requestId,
      action: action,
      reason: reason,
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
