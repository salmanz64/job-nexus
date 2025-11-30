import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jobnexus/features/chat/models/chat_preview_model.dart';
import 'package:jobnexus/features/chat/repository/chat_remote_repository.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:fpdart/fpdart.dart';

part 'chat_preview_view_model.g.dart';

@riverpod
class ChatPreviewViewModel extends _$ChatPreviewViewModel {
  late ChatRemoteRepository _chatRepo;
  late AuthLocalRepository _authLocalRepo;

  @override
  Future<List<ChatPreviewModel>> build() async {
    _chatRepo = ref.watch(chatRemoteRepositoryProvider);
    _authLocalRepo = ref.watch(authLocalRepositoryProvider);

    return fetchChatPreviews();
  }

  /// ------------------------------------------------------------
  /// 📌 Fetch Preview Conversations
  /// ------------------------------------------------------------
  Future<List<ChatPreviewModel>> fetchChatPreviews() async {
    final token = _authLocalRepo.getToken();
    final currentUserId = _authLocalRepo.getUserId();

    if (token == null || currentUserId == null) {
      throw Exception("User not authenticated");
    }

    final res = await _chatRepo.fetchChatPreview(
      token: token,
      userId: currentUserId,
    );

    return res.match(
      (failure) => throw Exception(failure.message),
      (previews) => previews,
    );
  }
}
