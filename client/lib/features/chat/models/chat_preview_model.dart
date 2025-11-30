// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatPreviewModel {
  final String userId; // actual user id
  final String profileId; // profile id (used for chat routing)
  final String name;
  final String? profileImage;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;

  ChatPreviewModel({
    required this.userId,
    required this.profileId,
    required this.name,
    this.profileImage,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
  });

  factory ChatPreviewModel.fromMap(Map<String, dynamic> map) {
    return ChatPreviewModel(
      userId: map['user_id']?.toString() ?? '',
      profileId: map['profile_id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown',
      profileImage: map['profile_image']?.toString(),
      lastMessage: map['last_message']?.toString() ?? '',
      timestamp:
          DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      unreadCount:
          map['unread_count'] is int
              ? map['unread_count']
              : int.tryParse(map['unread_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'profile_id': profileId,
      'name': name,
      'profile_image': profileImage,
      'last_message': lastMessage,
      'timestamp': timestamp.toIso8601String(),
      'unread_count': unreadCount,
    };
  }

  String toJson() => json.encode(toMap());

  factory ChatPreviewModel.fromJson(String source) =>
      ChatPreviewModel.fromMap(json.decode(source));
}
