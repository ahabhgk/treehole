import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/utils/ui.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  static const String route = '/my_likes';

  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();
    _loadMyLikedPosts();
  }

  void _loadMyLikedPosts() async {
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    try {
      final posts = await RepositoryProvider.of<PostRepository>(context)
          .fetchLikedPostsByUserId(id);
      setState(() {
        _posts = posts;
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error fetch user liked posts');
    } catch (e) {
      context.showErrorSnackbar('Error fetch user liked posts');
    }
  }

  Future<void> _onLikeTap(String postId) async {
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    try {
      await RepositoryProvider.of<PostRepository>(context)
          .likePost(userId: id, postId: postId);
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
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    try {
      await RepositoryProvider.of<PostRepository>(context)
          .unlikePost(userId: id, postId: postId);
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
      return ListView(
        children: withDivider(posts
            .map((post) => PostWidget(
                  username: post.username,
                  avatarUrl: post.avatarUrl,
                  content: post.content,
                  likeCount: post.likeCount,
                  isLiked: post.isLiked,
                  createdAt: post.createdAt,
                  onLikeTap: () => _onLikeTap(post.id),
                  onUnlikeTap: () => _onUnlikeTap(post.id),
                ))
            .toList()),
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
            const Header(
              child: Text(
                'My Likes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: _buildPosts()),
          ],
        ),
      ),
    );
  }
}