import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:jobnexus/features/auth/repository/auth_remote_repository.dart';
import 'package:jobnexus/features/profile/repository/profile_remote_repository.dart';
import 'package:jobnexus/features/profile/viewmodal/profile_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:jobnexus/features/chat/models/message_model.dart';
import 'package:jobnexus/features/chat/repository/chat_remote_repository.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  late ChatRemoteRepository _chatRepo;
  late AuthLocalRepository _authLocalRepo;
  StreamSubscription<MessageModel>? _subscription;

  @override
  AsyncValue<List<MessageModel>> build() {
    // 👇 Correct cleanup mechanism
    ref.onDispose(() {
      _subscription?.cancel();
      _chatRepo.disconnect();
    });

    _chatRepo = ref.watch(chatRemoteRepositoryProvider);
    _authLocalRepo = ref.watch(authLocalRepositoryProvider);
    return const AsyncValue.loading();
  }

  /// ----------------------------------------------------------
  /// 🔌 CONNECT TO WEBSOCKET + LOAD HISTORY + LISTEN UPDATES
  /// ----------------------------------------------------------
  Future<void> connect(String otherProfileId) async {
    state = const AsyncValue.loading();

    // Ensure profile is loaded once
    final myId = ref.read(authLocalRepositoryProvider).getUserId();

    // CONNECT WEBSOCKET
    await _chatRepo.connect(myId!);

    // LOAD HISTORY
    await loadHistory(otherProfileId);

    // Listen for live messages
    _subscription = _chatRepo.messagesStream().listen((msg) {
      if (!ref.mounted) return; // <---- important fix

      state = state.whenData((existing) => [...existing, msg]);
    });
  }

  /// --------------------------------------
  /// 📜 Load Chat History (HTTP)
  /// --------------------------------------
  Future<void> loadHistory(String otherProfileID) async {
    final token = _authLocalRepo.getToken();

    final otherUserID = await ref
        .read(authRemoteRepositoryProvider)
        .getUserIdFromProfile(otherProfileID);

    final res = await _chatRepo.fetchMessageHistory(
      token: token!,
      user1: _authLocalRepo.getUserId()!, // assuming saved locally
      user2: otherUserID,
    );

    res.match(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (messages) => state = AsyncValue.data(messages),
    );
  }

  /// --------------------------------------
  /// ✉ Send a new message
  /// --------------------------------------
  void sendMessage({required String receiverId, required String message}) {
    final senderId = _authLocalRepo.getUserId()!;

    _chatRepo.sendMessage(receiverId: receiverId, message: message);

    // Optional: instantly add it to UI (optimistic update)
    final newMessage = MessageModel(
      id: "",
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      isDelivered: false,
      isSeen: false,
    );

    state = state.whenData((old) => [...old, newMessage]);
  }
}
