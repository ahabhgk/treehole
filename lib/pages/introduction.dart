import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/pie.dart';
import 'package:treehole/models/emotion.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/my_likes.dart';
import 'package:treehole/pages/my_pals.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/pages/tabs/profile.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/follow.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/repositories/profile.dart';
import 'package:treehole/services/counts.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/ui.dart';

void goUserIntroductionPage(BuildContext context, Profile profile) {
  Navigator.of(context).pushNamed(IntroductionPage.route, arguments: profile);
}

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key, required this.profile}) : super(key: key);

  final Profile profile;

  static const String route = '/introduction';

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  bool? _isMyPal = false; // null for user is yourself
  Emotion _emotion =
      Emotion(joy: 20, mild: 20, disgust: 20, depressed: 20, anger: 20);
  String _todayEmoji = justsosoEmoji;

  void _getTodayEmotion() async {
    final emotions = await RepositoryProvider.of<PostRepository>(context)
        .fetchTodayPostEmotionsByAuthorId(widget.profile.id);
    final todayEmoji =
        emotions.reduce((acc, cur) => acc + cur).toMaxEmotionEmoji();
    setState(() {
      _todayEmoji = todayEmoji;
    });
  }

  void _fetchUserEmotion() async {
    final emotion = await RepositoryProvider.of<ProfileRepository>(context)
        .fetchUserEmotion(widget.profile.id);
    setState(() {
      _emotion = emotion;
    });
  }

  void _getCounts() async {
    BlocProvider.of<CountsCubit>(context).getCounts();
  }

  void _getIsMyPal(String myId) async {
    final myPals = await RepositoryProvider.of<FollowRepository>(context)
        .fetchPalsProfileByUserId(myId);
    final isMyPal =
        myPals.where((pal) => pal.id == widget.profile.id).isNotEmpty;
    setState(() {
      _isMyPal = isMyPal;
    });
  }

  void _breakUp() {
    setState(() {
      _isMyPal = false;
    });
  }

  void _requestToBePals() {
    setState(() {
      _isMyPal = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCounts();
    _fetchUserEmotion();
    _getTodayEmotion();
    final myId =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    if (myId != widget.profile.id) {
      _getIsMyPal(myId);
    } else {
      setState(() {
        _isMyPal = null;
      });
    }
  }

  Widget _buildContent() {
    return Column(
      children: [
        // user info
        Container(
          padding: const EdgeInsets.only(
            bottom: 12,
            left: 12,
            right: 12,
            top: 24,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 102 / 2,
                child: CircleAvatar(
                  radius: 96 / 2,
                  backgroundColor: Theme.of(context).backgroundColor,
                  backgroundImage: NetworkImage(
                      widget.profile.avatarUrl ?? defaultAvatarUrl),
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
                          widget.profile.username,
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
                        builder: (context, state) => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PairText(
                              count: state.postsCount,
                              name: 'Posts',
                              onTap: () async {
                                await goMyPostsPage(
                                  context,
                                  widget.profile.id,
                                );
                                _getCounts();
                              },
                            ),
                            PairText(
                              count: state.palsCount,
                              name: 'Pals',
                              onTap: () async {
                                await goMyPalsPage(
                                  context,
                                  widget.profile.id,
                                );
                                _getCounts();
                              },
                            ),
                            PairText(
                              count: state.likesCount,
                              name: 'Likes',
                              onTap: () async {
                                await goMyLikesPage(
                                  context,
                                  widget.profile.id,
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
              )
            ],
          ),
        ),
        // add pal
        Container(
          margin: const EdgeInsets.only(left: 102 + 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _isMyPal == true
              ? ElevatedButton(
                  onPressed: () {
                    _breakUp();
                  },
                  child: const Text('This is my pal~'),
                )
              : OutlinedButton(
                  onPressed: () {
                    if (_isMyPal == null) {
                      context.showSnackbar('Be your own best friend~ 😉');
                    } else {
                      _requestToBePals();
                    }
                  },
                  child: const Text('Request to be pals'),
                ),
        ),
        // emotion pie
        const SizedBox(height: 24),
        const Divider(height: 2, indent: 12, endIndent: 12),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Emotion: ',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Pie(emotion: _emotion),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Introduction'),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
}
