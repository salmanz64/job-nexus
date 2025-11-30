// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatViewModel)
const chatViewModelProvider = ChatViewModelProvider._();

final class ChatViewModelProvider
    extends $NotifierProvider<ChatViewModel, AsyncValue<List<MessageModel>>> {
  const ChatViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatViewModelHash();

  @$internal
  @override
  ChatViewModel create() => ChatViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<MessageModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<MessageModel>>>(
        value,
      ),
    );
  }
}

String _$chatViewModelHash() => r'ae88830c2a7bd43aca809713df8e6b3161a932e6';

abstract class _$ChatViewModel
    extends $Notifier<AsyncValue<List<MessageModel>>> {
  AsyncValue<List<MessageModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MessageModel>>,
              AsyncValue<List<MessageModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MessageModel>>,
                AsyncValue<List<MessageModel>>
              >,
              AsyncValue<List<MessageModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
