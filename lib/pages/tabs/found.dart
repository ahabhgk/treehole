import 'package:flutter/material.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/post.dart';

class FoundTabPage extends StatefulWidget {
  const FoundTabPage({Key? key}) : super(key: key);

  @override
  _FoundTabPageState createState() => _FoundTabPageState();
}

class _FoundTabPageState extends State<FoundTabPage> {
  final TextEditingController _searchController = TextEditingController();

  void _onShowFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FilterDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
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
                child: const SizedBox(
                  height: 36,
                  width: 36,
                  child: Icon(Icons.filter_alt_outlined),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              PostWidget(
                username: 'ahahbahahha',
                avatarUrl:
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                content:
                    'hahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhah',
                likes: 100,
                createdAt: DateTime.parse('2012-02-27 13:27:00'),
              ),
              PostWidget(
                username: 'ahahbahahha',
                avatarUrl:
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                content:
                    'hahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhaha',
                likes: 100,
                createdAt: DateTime.parse('2012-02-27 13:27:00'),
              ),
              PostWidget(
                username: 'ahahbahahha',
                avatarUrl:
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                content:
                    'hahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahh',
                likes: 100,
                createdAt: DateTime.parse('2012-02-27 13:27:00'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum OrderBy {
  suitability,
  hot,
  time,
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
