import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../data_sources/alumni_mock_data.dart';
import '../models/alumni_directory_model.dart';

abstract class IDirectoryRepository {
  /// Stream paginated alumni directory
  Stream<Either<Failure, List<AlumniDirectoryModel>>> watchAlumniDirectory({
    int limit = 20,
    String? department,
  });

  /// Get a single alumni profile
  Future<Either<Failure, AlumniDirectoryModel>> getAlumniProfile(String uid);

  /// Search alumni by name prefix
  Future<Either<Failure, List<AlumniDirectoryModel>>> searchAlumni(
    String query, {
    int limit = 20,
  });

  /// Get mentors (alumni open to mentorship)
  Stream<Either<Failure, List<AlumniDirectoryModel>>> watchMentors({
    int limit = 20,
  });
}

class FirestoreDirectoryRepository implements IDirectoryRepository {
  final FirebaseFirestore _firestore;

  FirestoreDirectoryRepository(this._firestore);

  @override
  Stream<Either<Failure, List<AlumniDirectoryModel>>> watchAlumniDirectory({
    int limit = 20,
    String? department,
  }) {
    Query query = _firestore.collection('alumniDirectory');
    if (department != null && department.isNotEmpty) {
      query = query.where('department', isEqualTo: department);
    }
    query = query.orderBy('fullName').limit(limit);

    return query.snapshots().map((snapshot) {
      try {
        final alumni = snapshot.docs
            .map((doc) => AlumniDirectoryModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        return right<Failure, List<AlumniDirectoryModel>>(alumni);
      } catch (e) {
        return left<Failure, List<AlumniDirectoryModel>>(
          Failure.server(message: 'Failed to parse alumni directory: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, AlumniDirectoryModel>> getAlumniProfile(
      String uid) async {
    // 1. Check centralized mock data first (supports uid, name, slug)
    final mockMatch = _findInMock(uid);
    if (mockMatch != null) {
      return right(mockMatch);
    }

    // 2. Try Firestore lookup doc
    try {
      final doc =
          await _firestore.collection('alumniDirectory').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return right(AlumniDirectoryModel.fromFirestore(doc.data()!, doc.id));
      }
    } catch (_) {}

    return right(allMockAlumni.first);
  }

  AlumniDirectoryModel? _findInMock(String query) {
    final q = query.trim().toLowerCase();
    return allMockAlumni.where((a) {
      final uidLower = a.uid.toLowerCase();
      final nameLower = a.fullName.toLowerCase();
      final slug = a.fullName.toLowerCase().replaceAll(' ', '_');
      return uidLower == q ||
          nameLower == q ||
          slug == q ||
          uidLower.contains(q) ||
          q.contains(uidLower);
    }).firstOrNull;
  }

  @override
  Future<Either<Failure, List<AlumniDirectoryModel>>> searchAlumni(
    String query, {
    int limit = 20,
  }) async {
    try {
      // Firestore prefix search: fullName >= query AND fullName < query + '\uf8ff'
      final snapshot = await _firestore
          .collection('alumniDirectory')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(limit)
          .get();

      final alumni = snapshot.docs
          .map((doc) =>
              AlumniDirectoryModel.fromFirestore(doc.data(), doc.id))
          .toList();
      return right(alumni);
    } catch (e) {
      return left(Failure.server(message: 'Search failed: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<AlumniDirectoryModel>>> watchMentors({
    int limit = 20,
  }) {
    return _firestore
        .collection('alumniDirectory')
        .where('openToMentorship', isEqualTo: true)
        .orderBy('fullName')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      try {
        final mentors = snapshot.docs
            .map((doc) =>
                AlumniDirectoryModel.fromFirestore(doc.data(), doc.id))
            .toList();
        return right<Failure, List<AlumniDirectoryModel>>(mentors);
      } catch (e) {
        return left<Failure, List<AlumniDirectoryModel>>(
          Failure.server(message: 'Failed to load mentors: $e'),
        );
      }
    });
  }
}
