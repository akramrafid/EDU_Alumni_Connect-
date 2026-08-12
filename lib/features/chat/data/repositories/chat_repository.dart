import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class IChatRepository {
  /// Watch conversations for the current user
  Stream<Either<Failure, List<ConversationModel>>> watchConversations(
      String currentUid);

  /// Watch messages in a conversation
  Stream<Either<Failure, List<MessageModel>>> watchMessages(
    String conversationId, {
    int limit = 50,
  });

  /// Send a text message
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    String type = 'text',
    String? mediaUrl,
    String? fileName,
    String? fileSize,
    String? duration,
  });

  /// Get or create a 1:1 conversation (via Cloud Function)
  Future<Either<Failure, String>> getOrCreateConversation(String otherUserId);

  /// Mark conversation as read for the current user
  Future<Either<Failure, Unit>> markConversationRead({
    required String conversationId,
    required String currentUid,
  });
}

class FirestoreChatRepository implements IChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;

  FirestoreChatRepository(this._firestore, this._functions, this._storage);

  @override
  Stream<Either<Failure, List<ConversationModel>>> watchConversations(
      String currentUid) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: currentUid)
        .snapshots()
        .map((snapshot) {
      try {
        final conversations = snapshot.docs
            .map((doc) =>
                ConversationModel.fromFirestore(doc.data(), doc.id))
            .toList();

        // Sort in memory by lastMessageAt descending to avoid requiring composite indexes
        conversations.sort((a, b) {
          final aTime = a.lastMessageAt ?? DateTime(0);
          final bTime = b.lastMessageAt ?? DateTime(0);
          return bTime.compareTo(aTime);
        });

        return right<Failure, List<ConversationModel>>(conversations);
      } catch (e) {
        return left<Failure, List<ConversationModel>>(
          Failure.server(message: 'Failed to load conversations: $e'),
        );
      }
    });
  }

  @override
  Stream<Either<Failure, List<MessageModel>>> watchMessages(
    String conversationId, {
    int limit = 50,
  }) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .limitToLast(limit)
        .snapshots()
        .map((snapshot) {
      try {
        final messages = snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc.data(), doc.id))
            .toList();
        return right<Failure, List<MessageModel>>(messages);
      } catch (e) {
        return left<Failure, List<MessageModel>>(
          Failure.server(message: 'Failed to load messages: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    String type = 'text',
    String? mediaUrl,
    String? fileName,
    String? fileSize,
    String? duration,
  }) async {
    try {
      final message = MessageModel(
        messageId: '',
        senderId: senderId,
        text: text,
        type: type,
        mediaUrl: mediaUrl,
        fileName: fileName,
        fileSize: fileSize,
        duration: duration,
        sentAt: DateTime.now(),
        readBy: [senderId],
      );

      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        ...message.toFirestore(),
        'sentAt': FieldValue.serverTimestamp(),
      });

      return right(unit);
    } catch (e) {
      return left(Failure.server(message: 'Failed to send message: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getOrCreateConversation(
      String otherUserId) async {
    try {
      final callable = _functions.httpsCallable('getOrCreateConversation');
      final result = await callable.call({'otherUserId': otherUserId});
      final data = result.data as Map<String, dynamic>;
      return right(data['conversationId'] as String);
    } on FirebaseFunctionsException catch (e) {
      return left(
          Failure.server(message: e.message ?? 'Failed to create conversation'));
    } catch (e) {
      return left(
          Failure.server(message: 'Failed to create conversation: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markConversationRead({
    required String conversationId,
    required String currentUid,
  }) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .update({
        'unreadCount.$currentUid': 0,
      });
      return right(unit);
    } catch (e) {
      return left(Failure.server(message: 'Failed to mark as read: $e'));
    }
  }
}
