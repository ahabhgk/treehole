import 'package:flutter/material.dart';
import 'package:treehole/components/post.dart';

class FoundTabPage extends StatefulWidget {
  const FoundTabPage({Key? key}) : super(key: key);

  @override
  _FoundTabPageState createState() => _FoundTabPageState();
}

class _FoundTabPageState extends State<FoundTabPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 36,
          margin: const EdgeInsets.all(12),
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
                onTap: () {},
                child: const SizedBox(
                  height: 36,
                  width: 36,
                  child: Icon(Icons.filter_alt_outlined),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 2),
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
                updateAt: DateTime.parse('2012-02-27 13:27:00'),
              ),
              PostWidget(
                username: 'ahahbahahha',
                avatarUrl:
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                content:
                    'hahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhaha',
                likes: 100,
                updateAt: DateTime.parse('2012-02-27 13:27:00'),
              ),
              PostWidget(
                username: 'ahahbahahha',
                avatarUrl:
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg',
                content:
                    'hahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahhahahhahahahahahhahh',
                likes: 100,
                updateAt: DateTime.parse('2012-02-27 13:27:00'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
