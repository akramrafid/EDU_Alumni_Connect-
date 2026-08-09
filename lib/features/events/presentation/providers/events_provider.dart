import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../data/models/event_model.dart';

part 'events_provider.g.dart';

@riverpod
Stream<List<EventModel>> upcomingEvents(UpcomingEventsRef ref) {
  final repo = ref.watch(eventRepositoryProvider);
  return repo.watchUpcomingEvents().map(
        (either) => either.fold(
          (failure) => <EventModel>[],
          (events) => events,
        ),
      );
}

@riverpod
class RsvpNotifier extends _$RsvpNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> toggleRsvp({
    required String eventId,
    required bool currentRsvpStatus,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(eventRepositoryProvider);
    final result = await repo.rsvpEvent(
      eventId: eventId,
      isRsvp: !currentRsvpStatus,
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
