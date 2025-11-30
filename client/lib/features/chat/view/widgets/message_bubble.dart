import 'package:flutter/material.dart';
import 'package:jobnexus/features/chat/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isthem; // true => message from THEM, false => message from YOU
  final String? profileImage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isthem,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isthem ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isthem ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
              isthem ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isthem ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: isthem ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, "0")}";
  }
}
