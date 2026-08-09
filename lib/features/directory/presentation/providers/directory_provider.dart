import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../data/models/alumni_directory_model.dart';

part 'directory_provider.g.dart';

@riverpod
Stream<List<AlumniDirectoryModel>> alumniDirectory(
  AlumniDirectoryRef ref, {
  String? department,
}) {
  final repo = ref.watch(directoryRepositoryProvider);
  return repo.watchAlumniDirectory(department: department).map(
        (either) => either.fold(
          (failure) => <AlumniDirectoryModel>[],
          (alumni) => alumni,
        ),
      );
}

@riverpod
Stream<List<AlumniDirectoryModel>> mentorsList(MentorsListRef ref) {
  final repo = ref.watch(directoryRepositoryProvider);
  return repo.watchMentors().map(
        (either) => either.fold(
          (failure) => <AlumniDirectoryModel>[],
          (mentors) => mentors,
        ),
      );
}

@riverpod
Future<List<AlumniDirectoryModel>> searchAlumni(
  SearchAlumniRef ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];
  final repo = ref.watch(directoryRepositoryProvider);
  final result = await repo.searchAlumni(query.trim());
  return result.fold(
    (failure) => [],
    (alumni) => alumni,
  );
}
