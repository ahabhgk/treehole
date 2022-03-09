import 'package:treehole/utils/constants.dart';

class Profile {
  Profile({
    required this.id,
    required this.username,
    this.avatarUrl,
  });

  final String id;
  final String username;
  final String? avatarUrl;

  Profile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        avatarUrl = json['avatar_url'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };
  }

  static final emptyProfile = Profile(
    id: '',
    username: 'No user for now...',
    avatarUrl: anonymousAvatarUrl,
  );

  bool isEmpty() {
    return id == '';
  }
}
