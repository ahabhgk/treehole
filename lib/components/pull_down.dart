import 'package:flutter/material.dart';
import 'package:treehole/utils/constants.dart';

class PullDown extends StatefulWidget {
  const PullDown({
    Key? key,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.itemCount,
  }) : super(key: key);

  final Future<void> Function() onLoadMore;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  @override
  _PullDownState createState() => _PullDownState();
}

class _PullDownState extends State<PullDown> {
  final ScrollController _controller = ScrollController();
  bool _isLoadingMore = false;

  void _onLoadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    await widget.onLoadMore();
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >
              _controller.position.maxScrollExtent - loadMoreDistance &&
          !_isLoadingMore) {
        _onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      itemCount: widget.itemCount,
      separatorBuilder: (context, index) => const Divider(
        height: 2,
        indent: 12,
        endIndent: 12,
      ),
      itemBuilder: widget.itemBuilder,
      // children: withDivider(widget.items),
    );
  }
}
