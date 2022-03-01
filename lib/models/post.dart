enum Permission {
  self,
  anonymousForPals,
  pal,
  anonymousForAnyone,
  anyone,
}

bool isAnonymous(Permission permission) {
  return permission == Permission.anonymousForAnyone ||
      permission == Permission.anonymousForPals;
}

class Post {
  Post({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    required this.isLiked,
    required this.username,
    required this.authorId,
    required this.avatarUrl,
    required this.permission,
  });

  final String id;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final String username;
  final String? avatarUrl;
  final int likeCount;
  final bool isLiked;
  final Permission permission;

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        createdAt = DateTime.parse(json['created_at']),
        authorId = json['author_id'],
        username = json['username'],
        avatarUrl = json['avatar_url'],
        likeCount = json['like_count'],
        isLiked = json['is_liked'],
        permission = Permission.values[json['permission']];
}
