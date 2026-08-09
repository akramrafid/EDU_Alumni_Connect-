import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../models/job_model.dart';

abstract class IJobRepository {
  /// Watch active job postings
  Stream<Either<Failure, List<JobModel>>> watchActiveJobs({int limit = 20});

  /// Get a single job by ID
  Future<Either<Failure, JobModel>> getJob(String jobId);

  /// Post a new job (via Cloud Function)
  Future<Either<Failure, String>> postJob({
    required String title,
    required String company,
    required String location,
    required String jobType,
    required String description,
    required String applyLink,
  });

  /// Close a job listing
  Future<Either<Failure, Unit>> closeJob(String jobId);
}

class FirestoreJobRepository implements IJobRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  FirestoreJobRepository(this._firestore, this._functions);

  @override
  Stream<Either<Failure, List<JobModel>>> watchActiveJobs({int limit = 20}) {
    return _firestore
        .collection('jobPostings')
        .where('status', isEqualTo: 'active')
        .orderBy('postedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      try {
        final jobs = snapshot.docs
            .map((doc) => JobModel.fromFirestore(doc.data(), doc.id))
            .toList();
        return right<Failure, List<JobModel>>(jobs);
      } catch (e) {
        return left<Failure, List<JobModel>>(
          Failure.server(message: 'Failed to load jobs: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, JobModel>> getJob(String jobId) async {
    try {
      final doc =
          await _firestore.collection('jobPostings').doc(jobId).get();
      if (!doc.exists) {
        return left(const Failure.notFound(message: 'Job not found'));
      }
      return right(JobModel.fromFirestore(doc.data()!, doc.id));
    } catch (e) {
      return left(Failure.server(message: 'Failed to get job: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> postJob({
    required String title,
    required String company,
    required String location,
    required String jobType,
    required String description,
    required String applyLink,
  }) async {
    try {
      final callable = _functions.httpsCallable('postJob');
      final result = await callable.call({
        'title': title,
        'company': company,
        'location': location,
        'jobType': jobType,
        'description': description,
        'applyLink': applyLink,
      });
      final data = result.data as Map<String, dynamic>;
      return right(data['jobId'] as String);
    } on FirebaseFunctionsException catch (e) {
      return left(Failure.server(message: e.message ?? 'Failed to post job'));
    } catch (e) {
      return left(Failure.server(message: 'Failed to post job: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> closeJob(String jobId) async {
    try {
      await _firestore.collection('jobPostings').doc(jobId).update({
        'status': 'closed',
      });
      return right(unit);
    } catch (e) {
      return left(Failure.server(message: 'Failed to close job: $e'));
    }
  }
}
