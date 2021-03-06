import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/utils.dart';
import 'package:treehole/utils/ui.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.authorId,
    required this.username,
    required this.createdAt,
    required this.content,
    required this.likeCount,
    required this.isLiked,
    required this.permission,
    this.avatarUrl,
    this.onAvatarTap,
    this.onLikeTap,
    this.onUnlikeTap,
  }) : super(key: key);

  final String authorId;
  final String username;
  final DateTime createdAt;
  final String content;
  final int likeCount;
  final bool isLiked;
  final Permission permission;
  final String? avatarUrl;
  final void Function()? onAvatarTap;
  final Future<void> Function()? onLikeTap;
  final Future<void> Function()? onUnlikeTap;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLikeLoading = false;

  void _onLikeTap() async {
    if (widget.authorId ==
        RepositoryProvider.of<AuthenticationRepository>(context).userId()) {
      context.showSnackbar('😅');
    }
    setState(() {
      isLikeLoading = true;
    });
    await widget.onLikeTap!();
    setState(() {
      isLikeLoading = false;
    });
  }

  void _onUnlikeTap() async {
    setState(() {
      isLikeLoading = true;
    });
    await widget.onUnlikeTap!();
    setState(() {
      isLikeLoading = false;
    });
  }

  void _onAvatarTap() {
    if (!isAnonymous(widget.permission) && widget.onAvatarTap != null) {
      widget.onAvatarTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _onAvatarTap,
                child: CircleAvatar(
                  radius: 48 / 2,
                  backgroundImage: NetworkImage(isAnonymous(widget.permission)
                      ? anonymousAvatarUrl
                      : widget.avatarUrl ?? defaultAvatarUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isAnonymous(widget.permission)
                            ? 'anonymous'
                            : widget.username,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getDisplayTime(widget.createdAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 48 + 12),
              Expanded(
                child: Text(
                  widget.content,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: widget.isLiked
                    ? widget.onUnlikeTap != null
                        ? _onUnlikeTap
                        : null
                    : widget.onLikeTap != null
                        ? _onLikeTap
                        : null,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                icon: Icon(isLikeLoading
                    ? Icons.change_circle_outlined
                    : widget.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border),
                label: Text(widget.likeCount.toString()),
              )
            ],
          ),
        ],
      ),
    );
  }
}
