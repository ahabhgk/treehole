import 'package:treehole/models/profile.dart';

class Post {
  Post({
    required this.id,
    required this.content,
    required this.createdAt,
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

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        createdAt = DateTime.parse(json['created_at']),
        authorId = json['author_id'],
        username = json['username'],
        avatarUrl = json['avatar_url'];

  Post.withProfile(Map<String, dynamic> json, {required Profile profile})
      : id = json['id'],
        content = json['content'],
        createdAt = DateTime.parse(json['created_at']),
        authorId = json['author_id'],
        username = profile.username,
        avatarUrl = profile.avatarUrl;
}
