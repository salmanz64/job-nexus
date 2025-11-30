// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_remote_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRemoteRepository)
const chatRemoteRepositoryProvider = ChatRemoteRepositoryProvider._();

final class ChatRemoteRepositoryProvider
    extends
        $FunctionalProvider<
          ChatRemoteRepository,
          ChatRemoteRepository,
          ChatRemoteRepository
        >
    with $Provider<ChatRemoteRepository> {
  const ChatRemoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRemoteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRemoteRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRemoteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatRemoteRepository create(Ref ref) {
    return chatRemoteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRemoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRemoteRepository>(value),
    );
  }
}

String _$chatRemoteRepositoryHash() =>
    r'e8825c32571fe383aaa37094720402c7494a6848';
