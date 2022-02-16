import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
    required this.username,
    required this.avatarUrl,
    required this.updateAt,
    required this.content,
    required this.likes,
  }) : super(key: key);

  final String username;
  final String avatarUrl;
  final DateTime updateAt;
  final String content;
  final int likes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 48 / 2,
                backgroundImage: NetworkImage(
                    'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        username,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        updateAt.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 48 + 12),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                icon: const Icon(Icons.favorite_border),
                label: Text(likes.toString()),
              )
            ],
          ),
        ],
      ),
    );
  }
}
