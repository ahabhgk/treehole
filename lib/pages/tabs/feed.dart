import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/components/retry.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/services/feed.dart';
import 'package:treehole/utils/ui.dart';

class FeedTabPage extends StatefulWidget {
  const FeedTabPage({Key? key}) : super(key: key);

  @override
  _FeedTabPageState createState() => _FeedTabPageState();
}

class _FeedTabPageState extends State<FeedTabPage> {
  Future<void> _loadFeeds() async {
    BlocProvider.of<FeedCubit>(context).loadFeeds();
  }

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(child: Image.asset('assets/treehole.png')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadFeeds,
            child: BlocConsumer<FeedCubit, FeedState>(
              listener: (context, state) {
                if (state is FeedError && state.posts != null) {
                  context.showErrorSnackbar(state.message);
                }
              },
              builder: (context, state) {
                if (state.posts != null) {
                  return ListView(
                    children: withDivider(state.posts!
                        .map((post) => PostWidget(
                              username: 'ahahbahahha',
                              avatarUrl:
                                  'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                              content: post.content,
                              likes: 100,
                              createdAt: post.createdAt,
                            ))
                        .toList()),
                  );
                } else if (state is FeedError) {
                  return Retry(onRetry: _loadFeeds);
                } else if (state is FeedLoading) {
                  return const Loading();
                } else {
                  throw Exception('Panic: unreachable.');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
