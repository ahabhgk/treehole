import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/my_likes.dart';
import 'package:treehole/pages/my_pals.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/pages/tabs/profile.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/follow.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
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
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.profile.username,
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
              )
            ],
          ),
        ),
        // add pal
        Container(
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
