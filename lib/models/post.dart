class Post {
  Post({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    required this.isLiked,
    this.username,
    this.authorId,
    this.avatarUrl,
  });

  final String id;
  final String? authorId; // null for anonymous
  final String content;
  final DateTime createdAt;
  final String? username; // null for anonymous
  final String? avatarUrl; // null for anonymous or default avatar
  final int likeCount;
  final bool isLiked;

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        createdAt = DateTime.parse(json['created_at']),
        authorId = json['author_id'],
        username = json['username'],
        avatarUrl = json['avatar_url'],
        likeCount = json['like_count'],
        isLiked = json['is_liked'];
}
