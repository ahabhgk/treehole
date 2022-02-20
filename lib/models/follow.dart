class Follow {
  Follow({
    required this.followingId,
    required this.followedId,
    this.createdAt,
  });

  final String followingId;
  final String followedId;
  final DateTime? createdAt;

  Follow.fromJson(Map<String, dynamic> json)
      : followingId = json['following_id'],
        followedId = json['followed_id'],
        createdAt = DateTime.parse(json['created_at']);

  Map<String, dynamic> toJson() {
    return {
      'following_id': followingId,
      'followed_id': followedId,
      'created_at': createdAt,
    };
  }
}
