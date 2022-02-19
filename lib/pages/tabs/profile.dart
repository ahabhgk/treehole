import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/pal.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/repositories/profile.dart';
import 'package:treehole/services/counts.dart';
import 'package:treehole/services/user.dart';
import 'package:treehole/utils/ui.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  void _getCounts() async {
    BlocProvider.of<CountsCubit>(context).getCounts();
  }

  @override
  void initState() {
    super.initState();
    _getCounts();
  }

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
                          BlocConsumer<CountsCubit, CountsState>(
                            listener: (context, state) {
                              if (state is CountsError) {
                                context.showErrorSnackbar(state.message);
                              }
                            },
                            builder: (context, state) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PairText(
                                  count: state.postsCount,
                                  name: 'Posts',
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(MyPostsPage.route);
                                  },
                                ),
                                PairText(
                                  count: state.palsCount,
                                  name: 'Pals',
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(MyPostsPage.route);
                                  },
                                ),
                                PairText(
                                  count: state.likesCount,
                                  name: 'Likes',
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(MyPostsPage.route);
                                  },
                                ),
                              ],
                            ),
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
    this.count,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final int? count;
  final String name;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            (count ?? '...').toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(name),
        ],
      ),
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
