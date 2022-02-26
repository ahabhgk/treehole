import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/empty.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/post.dart';
import 'package:treehole/components/retry.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/services/found.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/ui.dart';

class FoundTabPage extends StatefulWidget {
  const FoundTabPage({Key? key}) : super(key: key);

  @override
  _FoundTabPageState createState() => _FoundTabPageState();
}

class _FoundTabPageState extends State<FoundTabPage> {
  final ScrollController _controller = ScrollController();

  void _onShowFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FilterDialog();
      },
    );
  }

  Future<void> _search({String? keyword}) async {
    await BlocProvider.of<FoundCubit>(context).searchPosts(keyword);
  }

  Future<void> _onLikeTap(String postId) async {
    await BlocProvider.of<FoundCubit>(context).likePost(postId);
  }

  Future<void> _onUnlikeTap(String postId) async {
    await BlocProvider.of<FoundCubit>(context).unlikePost(postId);
  }

  void _loadMore() async {
    await BlocProvider.of<FoundCubit>(context).searchMorePosts();
  }

  @override
  void initState() {
    super.initState();
    _search();
    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - loadMoreDistance) {
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          child: BlocBuilder<FoundCubit, FoundState>(
            builder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      EasyDebounce.debounce(
                        'search-keyword',
                        const Duration(milliseconds: 300),
                        () => _search(keyword: value),
                      );
                    },
                    initialValue: state.keyword,
                    decoration: const InputDecoration(
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search',
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: _onShowFilterDialog,
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<FoundCubit, FoundState>(
            builder: (context, state) => RefreshIndicator(
              onRefresh: _search,
              child: BlocConsumer<FoundCubit, FoundState>(
                listener: (context, state) {
                  if (state is FoundError) {
                    context.showErrorSnackbar(state.message);
                  }
                },
                builder: (context, state) {
                  final posts = state.posts;
                  if (posts != null) {
                    if (posts.isEmpty) {
                      return const EmptyFiller(tips: 'No posts for now...');
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
                  } else if (state is FoundError) {
                    return Retry(onRetry: _search);
                  } else if (state is FoundLoading) {
                    return const Loading();
                  } else {
                    throw Exception('Panic: unreachable.');
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  OrderBy? _orderBy = OrderBy.hot;

  void _closeDialog() {
    return Navigator.of(context).pop();
  }

  void _setAndSearch() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search result settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order by: '),
              DropdownButton(
                value: _orderBy,
                items: const [
                  DropdownMenuItem(
                    child: Text('Suitability'),
                    value: OrderBy.suitability,
                  ),
                  DropdownMenuItem(
                    child: Text('Hot'),
                    value: OrderBy.hot,
                  ),
                  DropdownMenuItem(
                    child: Text('Time'),
                    value: OrderBy.time,
                  ),
                ],
                onChanged: (OrderBy? value) {
                  setState(() {
                    _orderBy = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(primary: Theme.of(context).errorColor),
          child: const Text('Cancel'),
          onPressed: _closeDialog,
        ),
        TextButton(
          child: const Text('Done'),
          onPressed: _setAndSearch,
        ),
      ],
    );
  }
}
