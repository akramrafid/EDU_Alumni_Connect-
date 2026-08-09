import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';

part 'chat_provider.g.dart';

@riverpod
Stream<List<ConversationModel>> userConversations(UserConversationsRef ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchConversations(user.uid).map(
        (either) => either.fold(
          (failure) => <ConversationModel>[],
          (convs) => convs,
        ),
      );
}

@riverpod
Stream<List<MessageModel>> conversationMessages(
  ConversationMessagesRef ref,
  String conversationId,
) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchMessages(conversationId).map(
        (either) => either.fold(
          (failure) => <MessageModel>[],
          (messages) => messages,
        ),
      );
}

@riverpod
class SendMessageNotifier extends _$SendMessageNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> send({
    required String conversationId,
    required String text,
    String type = 'text',
    String? mediaUrl,
    String? fileName,
    String? fileSize,
    String? duration,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    state = const AsyncLoading();
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.sendMessage(
      conversationId: conversationId,
      senderId: user.uid,
      text: text,
      type: type,
      mediaUrl: mediaUrl,
      fileName: fileName,
      fileSize: fileSize,
      duration: duration,
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
