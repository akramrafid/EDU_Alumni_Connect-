import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
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
    try {
      final doc =
          await _firestore.collection('alumniDirectory').doc(uid).get();
      if (!doc.exists) {
        return left(const Failure.notFound(message: 'Alumni not found'));
      }
      return right(AlumniDirectoryModel.fromFirestore(doc.data()!, doc.id));
    } catch (e) {
      return left(Failure.server(message: 'Failed to get alumni profile: $e'));
    }
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
