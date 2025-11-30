// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preview_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatPreviewViewModel)
const chatPreviewViewModelProvider = ChatPreviewViewModelProvider._();

final class ChatPreviewViewModelProvider
    extends
        $AsyncNotifierProvider<ChatPreviewViewModel, List<ChatPreviewModel>> {
  const ChatPreviewViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPreviewViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPreviewViewModelHash();

  @$internal
  @override
  ChatPreviewViewModel create() => ChatPreviewViewModel();
}

String _$chatPreviewViewModelHash() =>
    r'2bb3a9d2d06e9a4a60f6f910ccdc083758f5ac58';

abstract class _$ChatPreviewViewModel
    extends $AsyncNotifier<List<ChatPreviewModel>> {
  FutureOr<List<ChatPreviewModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ChatPreviewModel>>, List<ChatPreviewModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ChatPreviewModel>>,
                List<ChatPreviewModel>
              >,
              AsyncValue<List<ChatPreviewModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
