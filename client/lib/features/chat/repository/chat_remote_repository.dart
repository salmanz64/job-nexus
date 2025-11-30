import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:jobnexus/core/constants/server_constants.dart';
import 'package:jobnexus/core/failure/failure.dart';
import 'package:jobnexus/features/chat/models/message_model.dart';
import 'package:jobnexus/features/chat/models/chat_preview_model.dart';

part 'chat_remote_repository.g.dart';

@riverpod
ChatRemoteRepository chatRemoteRepository(Ref ref) {
  return ChatRemoteRepository();
}

class ChatRemoteRepository {
  WebSocketChannel? _channel;

  // -------------------- CONNECT --------------------
  Future<void> connect(String userId) async {
    // Convert HTTP → WS automatically
    final base =
        ServerConstants.serverUrl.startsWith("https")
            ? ServerConstants.serverUrl.replaceFirst("https", "wss")
            : ServerConstants.serverUrl.replaceFirst("http", "ws");

    final url = "$base/ws/chat/$userId";

    print("🔌 Connecting WebSocket: $url");
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  // -------------------- STREAM --------------------
  Stream<MessageModel> messagesStream() {
    if (_channel == null) {
      throw Exception("WebSocket not connected");
    }

    return _channel!.stream.map((event) {
      final data = jsonDecode(event);
      return MessageModel.fromMap(data);
    });
  }

  // -------------------- SEND --------------------
  void sendMessage({required String receiverId, required String message}) {
    if (_channel == null) {
      throw Exception("WebSocket not connected");
    }

    final payload = jsonEncode({"receiver_id": receiverId, "message": message});

    print("Sending WebSocket Message: $payload");
    _channel!.sink.add(payload);
  }

  // -------------------- FETCH MESSAGE HISTORY --------------------
  Future<Either<AppFailure, List<MessageModel>>> fetchMessageHistory({
    required String token,
    required String user1,
    required String user2,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/messages/$user1/$user2"),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to load messages"));
      }

      final List data = jsonDecode(response.body);
      final messages = data.map((e) => MessageModel.fromMap(e)).toList();

      return Right(messages);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // -------------------- FETCH CHAT PREVIEW LIST --------------------
  Future<Either<AppFailure, List<ChatPreviewModel>>> fetchChatPreview({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/chat/preview/$userId"),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );

      if (response.statusCode != 200) {
        return Left(AppFailure("Failed to fetch chat preview"));
      }

      final List data = jsonDecode(response.body);
      final previewList = data.map((e) => ChatPreviewModel.fromMap(e)).toList();

      return Right(previewList);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // -------------------- DISCONNECT --------------------
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
