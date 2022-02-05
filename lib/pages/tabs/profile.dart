import 'package:flutter/material.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  final int _postsCount = 54;
  final int _followersCount = 834;
  final int _followingCount = 12;
  final String username = '我的我的我的信息是这个页面';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // user info
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 102 / 2,
                child: CircleAvatar(
                  radius: 96 / 2,
                  backgroundImage: NetworkImage(
                      'https://www.meme-arsenal.com/memes/328f21c1cf3de885a0a805b90ed5a02b.jpg'),
                ),
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnTwoText(count: _postsCount, name: 'Posts'),
                        ColumnTwoText(
                            count: _followersCount, name: 'Followers'),
                        ColumnTwoText(
                            count: _followingCount, name: 'Following'),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // page list
        const Divider(height: 2, indent: 12, endIndent: 12),
        const SubPageListItem(
          icon: Icons.mood,
          iconColor: Colors.deepPurple,
          title: 'Mood',
        ),
        const Divider(height: 2, indent: 12, endIndent: 12),
        const SubPageListItem(
          icon: Icons.list,
          iconColor: Colors.blue,
          title: 'Quality',
        ),
        const Divider(height: 2, indent: 12, endIndent: 12),
        const SubPageListItem(
          icon: Icons.fiber_smart_record_outlined,
          iconColor: Colors.deepOrange,
          title: 'Match',
        ),
        const Divider(height: 2, indent: 12, endIndent: 12),
        const SubPageListItem(
          icon: Icons.settings,
          iconColor: Colors.blueGrey,
          title: 'Settings',
        ),
      ],
    );
  }
}

class ColumnTwoText extends StatelessWidget {
  const ColumnTwoText({
    Key? key,
    required this.count,
    required this.name,
  }) : super(key: key);

  final int count;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(name),
      ],
    );
  }
}

class SubPageListItem extends StatelessWidget {
  const SubPageListItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
