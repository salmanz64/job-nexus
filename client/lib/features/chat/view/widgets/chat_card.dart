import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/features/auth/repository/auth_remote_repository.dart';
import 'package:jobnexus/features/chat/models/chat_preview_model.dart';
import 'package:jobnexus/features/chat/view/pages/chat_screen.dart';

class ChatCard extends ConsumerWidget {
  final ChatPreviewModel chat;

  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage =
        chat.profileImage ??
        "https://ui-avatars.com/api/?name=${chat.name.replaceAll(" ", "+")}";

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(profileImage),
        ),
        title: Text(
          chat.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (chat.unreadCount > 0) ...[
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    chat.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
            Text(
              chat.timestamp.toString(),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return ChatScreen(
                  otherUserId: chat.profileId,
                  otherUserName: chat.name,
                  profileImage: null, // adjust based on model
                );
              },
            ),
          );
        },
      ),
    );
  }
}
