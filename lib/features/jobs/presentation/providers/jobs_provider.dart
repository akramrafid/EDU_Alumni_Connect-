import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../data/models/job_model.dart';

part 'jobs_provider.g.dart';

@riverpod
Stream<List<JobModel>> activeJobs(ActiveJobsRef ref) {
  final repo = ref.watch(jobRepositoryProvider);
  return repo.watchActiveJobs().map(
        (either) => either.fold(
          (failure) => <JobModel>[],
          (jobs) => jobs,
        ),
      );
}

@riverpod
class PostJobNotifier extends _$PostJobNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> post({
    required String title,
    required String company,
    required String location,
    required String jobType,
    required String description,
    required String applyLink,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(jobRepositoryProvider);
    final result = await repo.postJob(
      title: title,
      company: company,
      location: location,
      jobType: jobType,
      description: description,
      applyLink: applyLink,
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
