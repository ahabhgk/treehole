import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/pages/match.dart';
import 'package:treehole/pages/my_likes.dart';
import 'package:treehole/pages/my_pals.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/pages/settings.dart';
import 'package:treehole/services/counts.dart';
import 'package:treehole/services/user.dart';
import 'package:treehole/utils/constants.dart';
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
                        backgroundImage: NetworkImage(
                            state.profile.avatarUrl ?? defaultAvatarUrl),
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
                                  onTap: () async {
                                    await Navigator.of(context)
                                        .pushNamed(MyPostsPage.route);
                                    _getCounts();
                                  },
                                ),
                                PairText(
                                  count: state.palsCount,
                                  name: 'Pals',
                                  onTap: () async {
                                    await Navigator.of(context)
                                        .pushNamed(MyPalsPage.route);
                                    _getCounts();
                                  },
                                ),
                                PairText(
                                  count: state.likesCount,
                                  name: 'Likes',
                                  onTap: () async {
                                    await Navigator.of(context)
                                        .pushNamed(MyLikesPage.route);
                                    _getCounts();
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
              SubPageListItem(
                icon: Icons.mood,
                iconColor: Colors.deepPurple,
                title: 'Mood',
                onTap: () {
                  Navigator.of(context).pushNamed(MatchPage.route);
                },
              ),
              const Divider(height: 2, indent: 12, endIndent: 12),
              SubPageListItem(
                icon: Icons.list,
                iconColor: Colors.blue,
                title: 'Quality',
                onTap: () {
                  Navigator.of(context).pushNamed(MatchPage.route);
                },
              ),
              const Divider(height: 2, indent: 12, endIndent: 12),
              SubPageListItem(
                icon: Icons.fiber_smart_record_outlined,
                iconColor: Colors.deepOrange,
                title: 'Match',
                onTap: () {
                  Navigator.of(context).pushNamed(MatchPage.route);
                },
              ),
              const Divider(height: 2, indent: 12, endIndent: 12),
              SubPageListItem(
                icon: Icons.settings,
                iconColor: Colors.blueGrey,
                title: 'Settings',
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsPage.route);
                },
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
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
