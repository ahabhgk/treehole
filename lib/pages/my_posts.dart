import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/components/retry.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/utils/ui.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({Key? key}) : super(key: key);

  static const String route = '/my_posts';

  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _loadMyPosts();
  }

  void _loadMyPosts() {
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    _posts =
        RepositoryProvider.of<PostRepository>(context).fetchPostsByAuthorId(id);
  }

  Widget _buildPosts() {
    return FutureBuilder<List<Post>>(
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pals = snapshot.data!
              .map((post) => PostWidget(
                    username: post.username,
                    avatarUrl: post.avatarUrl,
                    content: post.content,
                    likeCount: post.likeCount,
                    isLiked: post.isLiked,
                    createdAt: post.createdAt,
                  ))
              .toList();
          return ListView(children: withDivider(pals));
        } else if (snapshot.hasError) {
          return Retry(onRetry: _loadMyPosts);
        } else {
          return const Loading();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(
              child: Text(
                'My Posts',
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
