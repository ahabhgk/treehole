import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/empty.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/components/retry.dart';
import 'package:treehole/services/feed.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/ui.dart';

class FeedTabPage extends StatefulWidget {
  const FeedTabPage({Key? key}) : super(key: key);

  @override
  _FeedTabPageState createState() => _FeedTabPageState();
}

class _FeedTabPageState extends State<FeedTabPage> {
  final ScrollController _controller = ScrollController();

  Future<void> _loadFeeds() async {
    BlocProvider.of<FeedCubit>(context).loadFeeds();
  }

  void _loadMore() async {
    await BlocProvider.of<FeedCubit>(context).loadMoreFeeds();
  }

  @override
  void initState() {
    super.initState();
    _loadFeeds();
    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - loadMoreDistance) {
        _loadMore();
      }
    });
  }

  Future<void> _onLikeTap(String postId) async {
    await BlocProvider.of<FeedCubit>(context).likePost(postId);
  }

  Future<void> _onUnlikeTap(String postId) async {
    await BlocProvider.of<FeedCubit>(context).unlikePost(postId);
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
                final posts = state.posts;
                if (posts != null) {
                  if (posts.isEmpty) {
                    return const EmptyFiller(tips: 'Go find more!');
                  } else {
                    return ListView(
                      controller: _controller,
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
                  }
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
