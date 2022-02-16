import 'package:flutter/material.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/post.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(child: Image.asset('assets/treehole.png')),
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
