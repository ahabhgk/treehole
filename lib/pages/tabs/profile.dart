import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/services/user.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  final int _postsCount = 54;
  final int _palsCount = 12;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Column(
            children: [
              // user info
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 102 / 2,
                      child: CircleAvatar(
                        radius: 96 / 2,
                        backgroundColor: Theme.of(context).backgroundColor,
                        backgroundImage: (state.profile.avatarUrl != null
                                ? NetworkImage(state.profile.avatarUrl!)
                                : const AssetImage('assets/default_avatar.png'))
                            as ImageProvider<Object>,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.profile.username,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PairText(count: _postsCount, name: 'Posts'),
                              const SizedBox(width: 36),
                              PairText(count: _palsCount, name: 'Pals'),
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
        } else {
          throw Exception('User should loaded.');
        }
      },
    );
  }
}

class PairText extends StatelessWidget {
  const PairText({
    Key? key,
    required this.count,
    required this.name,
  }) : super(key: key);

  final int count;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
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
