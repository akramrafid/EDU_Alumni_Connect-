// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userConversationsHash() => r'e57bbbcdecca7542e4c8823b845e9cd4797ed301';

/// See also [userConversations].
@ProviderFor(userConversations)
final userConversationsProvider =
    AutoDisposeStreamProvider<List<ConversationModel>>.internal(
  userConversations,
  name: r'userConversationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userConversationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserConversationsRef
    = AutoDisposeStreamProviderRef<List<ConversationModel>>;
String _$conversationMessagesHash() =>
    r'72b46c510e955ef575d7fcdb6054ef73a234fd7f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [conversationMessages].
@ProviderFor(conversationMessages)
const conversationMessagesProvider = ConversationMessagesFamily();

/// See also [conversationMessages].
class ConversationMessagesFamily
    extends Family<AsyncValue<List<MessageModel>>> {
  /// See also [conversationMessages].
  const ConversationMessagesFamily();

  /// See also [conversationMessages].
  ConversationMessagesProvider call(
    String conversationId,
  ) {
    return ConversationMessagesProvider(
      conversationId,
    );
  }

  @override
  ConversationMessagesProvider getProviderOverride(
    covariant ConversationMessagesProvider provider,
  ) {
    return call(
      provider.conversationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conversationMessagesProvider';
}

/// See also [conversationMessages].
class ConversationMessagesProvider
    extends AutoDisposeStreamProvider<List<MessageModel>> {
  /// See also [conversationMessages].
  ConversationMessagesProvider(
    String conversationId,
  ) : this._internal(
          (ref) => conversationMessages(
            ref as ConversationMessagesRef,
            conversationId,
          ),
          from: conversationMessagesProvider,
          name: r'conversationMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationMessagesHash,
          dependencies: ConversationMessagesFamily._dependencies,
          allTransitiveDependencies:
              ConversationMessagesFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    Stream<List<MessageModel>> Function(ConversationMessagesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationMessagesProvider._internal(
        (ref) => create(ref as ConversationMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageModel>> createElement() {
    return _ConversationMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMessagesProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ConversationMessagesRef
    on AutoDisposeStreamProviderRef<List<MessageModel>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageModel>>
    with ConversationMessagesRef {
  _ConversationMessagesProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationMessagesProvider).conversationId;
}

String _$sendMessageNotifierHash() =>
    r'2080b717b5bb5a9d6af6c44bc4b53058e459eadd';

/// See also [SendMessageNotifier].
@ProviderFor(SendMessageNotifier)
final sendMessageNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SendMessageNotifier, void>.internal(
  SendMessageNotifier.new,
  name: r'sendMessageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sendMessageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SendMessageNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
