import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../models/event_model.dart';

abstract class IEventRepository {
  /// Stream of upcoming events, ordered by dateTime ascending
  Stream<Either<Failure, List<EventModel>>> watchUpcomingEvents({int limit = 20});

  /// Get a single event by ID
  Future<Either<Failure, EventModel>> getEvent(String eventId);

  /// RSVP or cancel RSVP for an event (via Cloud Function)
  Future<Either<Failure, int>> rsvpEvent({
    required String eventId,
    required bool isRsvp,
  });
}
