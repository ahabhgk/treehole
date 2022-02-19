import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/services/my_posts.dart';
import 'package:treehole/utils/ui.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({Key? key}) : super(key: key);

  static const String route = '/my_posts';

  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  @override
  void initState() {
    super.initState();
    _loadMyPosts();
  }

  void _loadMyPosts() {
    BlocProvider.of<MyPostsCubit>(context).loadMyPosts();
  }

  Widget _buildPosts(MyPostsState state) {
    if (state is MyPostsLoading) {
      return const Loading();
    } else if (state is MyPostsLoaded) {
      final posts = state.posts
          .map((post) => PostWidget(
                username: 'ahahbahahha',
                avatarUrl:
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                content: post.content,
                likes: 100,
                createdAt: post.createdAt,
              ))
          .toList();
      return ListView(children: withDivider(posts));
    } else if (state is MyPostsLoadError) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).errorColor,
            ),
            TextButton(
              onPressed: () {
                _loadMyPosts();
              },
              child: const Text('retry'),
            ),
          ],
        ),
      );
    } else {
      throw Exception('Panic: unreachable');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPostsCubit, MyPostsState>(
      listener: (context, state) {
        if (state is MyPostsLoadError) {
          context.showErrorSnackbar(state.message);
        }
      },
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Header(
                child: Text(
                  'My Posts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: _buildPosts(state)),
            ],
          ),
        ),
      ),
    );
  }
}
