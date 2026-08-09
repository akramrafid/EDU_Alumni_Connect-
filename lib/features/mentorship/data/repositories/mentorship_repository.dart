import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../models/mentorship_request_model.dart';

abstract class IMentorshipRepository {
  /// Student sends a mentorship request (via Cloud Function)
  Future<Either<Failure, String>> sendRequest({
    required String alumniId,
    required String message,
  });

  /// Alumni responds to a mentorship request (via Cloud Function)
  Future<Either<Failure, Unit>> respondToRequest({
    required String requestId,
    required String action,
    String? reason,
  });

  /// Watch student's mentorship requests
  Stream<Either<Failure, List<MentorshipRequestModel>>> watchStudentRequests(
      String studentId);

  /// Watch alumni's incoming mentorship requests
  Stream<Either<Failure, List<MentorshipRequestModel>>> watchAlumniRequests(
      String alumniId);

  /// Check if student already has a pending/active request with an alumni
  Future<bool> hasPendingRequest({
    required String studentId,
    required String alumniId,
  });
}

class FirestoreMentorshipRepository implements IMentorshipRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  FirestoreMentorshipRepository(this._firestore, this._functions);

  @override
  Future<Either<Failure, String>> sendRequest({
    required String alumniId,
    required String message,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendMentorshipRequest');
      final result = await callable.call({
        'alumniId': alumniId,
        'message': message,
      });
      final data = result.data as Map<String, dynamic>;
      return right(data['requestId'] as String);
    } on FirebaseFunctionsException catch (e) {
      return left(
          Failure.server(message: e.message ?? 'Failed to send request'));
    } catch (e) {
      return left(Failure.server(message: 'Failed to send request: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> respondToRequest({
    required String requestId,
    required String action,
    String? reason,
  }) async {
    try {
      final callable =
          _functions.httpsCallable('respondToMentorshipRequest');
      await callable.call({
        'requestId': requestId,
        'action': action,
        if (reason != null) 'reason': reason,
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(
          Failure.server(message: e.message ?? 'Failed to respond'));
    } catch (e) {
      return left(Failure.server(message: 'Failed to respond: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<MentorshipRequestModel>>> watchStudentRequests(
      String studentId) {
    return _firestore
        .collection('mentorshipRequests')
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      try {
        final requests = snapshot.docs
            .map((doc) => MentorshipRequestModel.fromFirestore(
                doc.data(), doc.id))
            .toList();
        return right<Failure, List<MentorshipRequestModel>>(requests);
      } catch (e) {
        return left<Failure, List<MentorshipRequestModel>>(
          Failure.server(message: 'Failed to load requests: $e'),
        );
      }
    });
  }

  @override
  Stream<Either<Failure, List<MentorshipRequestModel>>> watchAlumniRequests(
      String alumniId) {
    return _firestore
        .collection('mentorshipRequests')
        .where('alumniId', isEqualTo: alumniId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      try {
        final requests = snapshot.docs
            .map((doc) => MentorshipRequestModel.fromFirestore(
                doc.data(), doc.id))
            .toList();
        return right<Failure, List<MentorshipRequestModel>>(requests);
      } catch (e) {
        return left<Failure, List<MentorshipRequestModel>>(
          Failure.server(message: 'Failed to load requests: $e'),
        );
      }
    });
  }

  @override
  Future<bool> hasPendingRequest({
    required String studentId,
    required String alumniId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('mentorshipRequests')
          .where('studentId', isEqualTo: studentId)
          .where('alumniId', isEqualTo: alumniId)
          .where('status', whereIn: ['pending', 'accepted'])
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
