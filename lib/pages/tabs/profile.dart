import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/emotion.dart';
import 'package:treehole/pages/introduction.dart';
import 'package:treehole/pages/match.dart';
import 'package:treehole/pages/my_likes.dart';
import 'package:treehole/pages/my_pals.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/pages/settings.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';
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
  String _todayEmoji = justsosoEmoji;

  void _getTodayEmotion() async {
    final userId =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    final emotions = await RepositoryProvider.of<PostRepository>(context)
        .fetchTodayPostEmotionsByAuthorId(userId);
    final todayEmoji =
        emotions.reduce((acc, cur) => acc + cur).toMaxEmotionEmoji();
    setState(() {
      _todayEmoji = todayEmoji;
    });
  }

  void _getCounts() async {
    BlocProvider.of<CountsCubit>(context).getCounts();
  }

  @override
  void initState() {
    super.initState();
    _getCounts();
    _getTodayEmotion();
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
                    GestureDetector(
                      onTap: () => goUserIntroductionPage(
                        context,
                        Profile(
                          id: state.profile.id,
                          username: state.profile.username,
                          avatarUrl: state.profile.avatarUrl,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 102 / 2,
                        child: CircleAvatar(
                          radius: 96 / 2,
                          backgroundColor: Theme.of(context).backgroundColor,
                          backgroundImage: NetworkImage(
                              state.profile.avatarUrl ?? defaultAvatarUrl),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 102,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.profile.username,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text('Today\'s emotion: $_todayEmoji'),
                            BlocConsumer<CountsCubit, CountsState>(
                              listener: (context, state) {
                                if (state is CountsError) {
                                  context.showErrorSnackbar(state.message);
                                }
                              },
                              builder: (context, countsState) => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PairText(
                                    count: countsState.postsCount,
                                    name: 'Posts',
                                    onTap: () async {
                                      await goMyPostsPage(
                                        context,
                                        state.profile.id,
                                      );
                                      _getCounts();
                                    },
                                  ),
                                  PairText(
                                    count: countsState.palsCount,
                                    name: 'Pals',
                                    onTap: () async {
                                      await goMyPalsPage(
                                        context,
                                        state.profile.id,
                                      );
                                      _getCounts();
                                    },
                                  ),
                                  PairText(
                                    count: countsState.likesCount,
                                    name: 'Likes',
                                    onTap: () async {
                                      await goMyLikesPage(
                                        context,
                                        state.profile.id,
                                      );
                                      _getCounts();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // page list
              const Divider(height: 2, indent: 12, endIndent: 12),
              SubPageListItem(
                icon: Icons.mood,
                iconColor: Colors.deepPurple,
                title: 'Emotion',
                onTap: () {
                  goEmotionPage(context, state.profile.id);
                },
              ),
              // const Divider(height: 2, indent: 12, endIndent: 12),
              // SubPageListItem(
              //   icon: Icons.list,
              //   iconColor: Colors.blue,
              //   title: 'Quality',
              //   onTap: () {
              //     Navigator.of(context).pushNamed(MatchPage.route);
              //   },
              // ),
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
    this.onTap,
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
