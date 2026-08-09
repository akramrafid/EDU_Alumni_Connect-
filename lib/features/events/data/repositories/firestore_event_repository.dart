import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../models/event_model.dart';
import 'event_repository.dart';

class FirestoreEventRepository implements IEventRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  FirestoreEventRepository(this._firestore, this._functions);

  @override
  Stream<Either<Failure, List<EventModel>>> watchUpcomingEvents(
      {int limit = 20}) {
    return _firestore
        .collection('events')
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('dateTime')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      try {
        final events = snapshot.docs
            .map((doc) => EventModel.fromFirestore(doc.data(), doc.id))
            .toList();
        return right<Failure, List<EventModel>>(events);
      } catch (e) {
        return left<Failure, List<EventModel>>(
          Failure.server(message: 'Failed to parse events: $e'),
        );
      }
    }).handleError((error) {
      return left<Failure, List<EventModel>>(
        Failure.server(message: 'Failed to watch events: $error'),
      );
    });
  }

  @override
  Future<Either<Failure, EventModel>> getEvent(String eventId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      if (!doc.exists) {
        return left(const Failure.notFound(message: 'Event not found'));
      }
      return right(EventModel.fromFirestore(doc.data()!, doc.id));
    } catch (e) {
      return left(Failure.server(message: 'Failed to get event: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> rsvpEvent({
    required String eventId,
    required bool isRsvp,
  }) async {
    try {
      final callable = _functions.httpsCallable('rsvpEvent');
      final result = await callable.call({
        'eventId': eventId,
        'action': isRsvp ? 'rsvp' : 'cancel',
      });
      final data = result.data as Map<String, dynamic>;
      return right(data['newRsvpCount'] as int);
    } on FirebaseFunctionsException catch (e) {
      return left(Failure.server(message: e.message ?? 'RSVP failed'));
    } catch (e) {
      return left(Failure.server(message: 'RSVP failed: $e'));
    }
  }
}
