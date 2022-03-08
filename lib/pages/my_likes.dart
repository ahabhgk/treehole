import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/components/pull_down.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/introduction.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/utils/ui.dart';

Future<void> goMyLikesPage(BuildContext context, String userId) {
  return Navigator.of(context).pushNamed(MyLikesPage.route, arguments: userId);
}

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  static const String route = '/likes';

  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  int _page = 0;
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();
    _loadMyLikedPosts();
  }

  Future<void> _loadMyLikedPosts() async {
    try {
      final morePosts = await RepositoryProvider.of<PostRepository>(context)
          .fetchLikedPostsByUserId(widget.userId, _page);
      final posts = (_posts ?? [])..addAll(morePosts);
      final page = morePosts.isEmpty ? _page : _page + 1;
      setState(() {
        _posts = posts;
        _page = page;
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error fetch user liked posts');
    } catch (e) {
      context.showErrorSnackbar('Error fetch user liked posts');
    }
  }

  Future<void> _onLikeTap(String postId) async {
    try {
      await RepositoryProvider.of<PostRepository>(context)
          .likePost(userId: widget.userId, postId: postId);
      setState(() {
        _posts = _posts!
            .map((e) => Post(
                  id: e.id,
                  content: e.content,
                  createdAt: e.createdAt,
                  likeCount: e.id == postId ? e.likeCount + 1 : e.likeCount,
                  isLiked: e.id == postId ? true : e.isLiked,
                  username: e.username,
                  authorId: e.authorId,
                  avatarUrl: e.avatarUrl,
                  permission: e.permission,
                ))
            .toList();
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error like post');
    } catch (e) {
      context.showErrorSnackbar('Error like post');
    }
  }

  Future<void> _onUnlikeTap(String postId) async {
    try {
      await RepositoryProvider.of<PostRepository>(context)
          .unlikePost(userId: widget.userId, postId: postId);
      setState(() {
        _posts = _posts!
            .map((e) => Post(
                  id: e.id,
                  content: e.content,
                  createdAt: e.createdAt,
                  likeCount: e.id == postId ? e.likeCount - 1 : e.likeCount,
                  isLiked: e.id == postId ? false : e.isLiked,
                  username: e.username,
                  authorId: e.authorId,
                  avatarUrl: e.avatarUrl,
                  permission: e.permission,
                ))
            .toList();
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error like post');
    } catch (e) {
      context.showErrorSnackbar('Error like post');
    }
  }

  Widget _buildPosts() {
    final posts = _posts;
    if (posts != null) {
      if (posts.isEmpty) {
        return const Center(child: Text('Go likes some posts~'));
      }
      return PullDown(
        onLoadMore: _loadMyLikedPosts,
        items: posts
            .map((post) => PostWidget(
                  authorId: post.authorId,
                  permission: post.permission,
                  username: post.username,
                  avatarUrl: post.avatarUrl,
                  content: post.content,
                  likeCount: post.likeCount,
                  isLiked: post.isLiked,
                  createdAt: post.createdAt,
                  onLikeTap: () => _onLikeTap(post.id),
                  onUnlikeTap: () => _onUnlikeTap(post.id),
                  onAvatarTap: () => goUserIntroductionPage(
                    context,
                    Profile(
                      id: post.authorId,
                      username: post.username,
                      avatarUrl: post.avatarUrl,
                    ),
                  ),
                ))
            .toList(),
      );
    } else {
      return const Loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Likes'),
            Expanded(child: _buildPosts()),
          ],
        ),
      ),
    );
  }
}
