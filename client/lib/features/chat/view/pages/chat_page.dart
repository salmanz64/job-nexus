import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/features/chat/view/widgets/chat_card.dart';
import 'package:jobnexus/features/chat/viewmodal/chat_preview_view_model.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatPreviewState = ref.watch(chatPreviewViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: chatPreviewState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (chats) {
          if (chats.isEmpty) {
            return const Center(
              child: Text("No messages yet 👀", style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (_, index) {
              return ChatCard(chat: chats[index]);
            },
          );
        },
      ),
    );
  }
}
