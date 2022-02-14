class Post {
  Post({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String content;
  final DateTime createdAt;

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        authorId = json['author_id'],
        content = json['content'],
        createdAt = DateTime.parse(json['created_at']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'content': content,
      'created_at': createdAt,
    };
  }
}
