enum NotificationKind {
  follow,
}

class Notification {
  Notification({
    required this.kind,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.senderUsername,
    required this.senderAvatarUrl,
    this.isFollowed,
  });

  final NotificationKind kind;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final String senderUsername;
  final String senderAvatarUrl;
  final bool? isFollowed;

  Notification.fromJson(Map<String, dynamic> json)
      : kind = NotificationKind.values[json['kind']],
        senderId = json['sender_id'],
        receiverId = json['receiver_id'],
        senderUsername = json['sender_username'],
        senderAvatarUrl = json['sender_avatar_url'],
        createdAt = DateTime.parse(json['created_at']),
        isFollowed = json['is_followed'];
}
