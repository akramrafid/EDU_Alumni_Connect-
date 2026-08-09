import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../models/notification_model.dart';

abstract class INotificationRepository {
  /// Watch notifications for the current user
  Stream<Either<Failure, List<NotificationModel>>> watchNotifications(
      String uid);

  /// Mark a notification as read
  Future<Either<Failure, Unit>> markAsRead({
    required String uid,
    required String notificationId,
  });

  /// Delete a notification
  Future<Either<Failure, Unit>> deleteNotification({
    required String uid,
    required String notificationId,
  });

  /// Get unread count
  Stream<Either<Failure, int>> watchUnreadCount(String uid);
}

class FirestoreNotificationRepository implements INotificationRepository {
  final FirebaseFirestore _firestore;

  FirestoreNotificationRepository(this._firestore);

  @override
  Stream<Either<Failure, List<NotificationModel>>> watchNotifications(
      String uid) {
    return _firestore
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      try {
        final notifications = snapshot.docs
            .map((doc) =>
                NotificationModel.fromFirestore(doc.data(), doc.id))
            .toList();
        return right<Failure, List<NotificationModel>>(notifications);
      } catch (e) {
        return left<Failure, List<NotificationModel>>(
          Failure.server(message: 'Failed to load notifications: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(uid)
          .collection('items')
          .doc(notificationId)
          .update({'read': true});
      return right(unit);
    } catch (e) {
      return left(Failure.server(message: 'Failed to mark as read: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(uid)
          .collection('items')
          .doc(notificationId)
          .delete();
      return right(unit);
    } catch (e) {
      return left(Failure.server(message: 'Failed to delete notification: $e'));
    }
  }

  @override
  Stream<Either<Failure, int>> watchUnreadCount(String uid) {
    return _firestore
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      try {
        return right<Failure, int>(snapshot.size);
      } catch (e) {
        return left<Failure, int>(
            Failure.server(message: 'Failed to get unread count: $e'));
      }
    });
  }
}
