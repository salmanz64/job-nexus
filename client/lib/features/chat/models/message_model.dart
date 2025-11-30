class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isDelivered;
  final bool isSeen;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isDelivered,
    required this.isSeen,
  });

  /// ---- Factory to convert JSON from backend / WebSocket ----
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id']?.toString() ?? "",
      senderId: map['senderId']?.toString() ?? "",
      receiverId: map['receiverId']?.toString() ?? "",
      message: map['content'] ?? map['message'] ?? "",
      timestamp: DateTime.tryParse(map['timestamp'] ?? "") ?? DateTime.now(),
      isDelivered: map['isDelivered'] ?? false,
      isSeen: map['isSeen'] ?? false,
    );
  }

  /// ---- Convert to JSON for sending to WebSocket/API ----
  Map<String, dynamic> toMap() {
    return {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "timestamp": timestamp.toIso8601String(),
      "is_delivered": isDelivered,
      "is_seen": isSeen,
    };
  }

  /// ---- Create a copy when updating message state ----
  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isDelivered,
    bool? isSeen,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isDelivered: isDelivered ?? this.isDelivered,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}
