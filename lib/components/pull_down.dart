import 'package:flutter/material.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/ui.dart';

class PullDown extends StatefulWidget {
  const PullDown({
    Key? key,
    required this.items,
    required this.onLoadMore,
  }) : super(key: key);

  final Future<void> Function() onLoadMore;
  final List<Widget> items;

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
    return ListView(
      controller: _controller,
      children: withDivider(widget.items),
    );
  }
}
