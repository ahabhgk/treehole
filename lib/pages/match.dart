import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/introduction.dart';
import 'package:treehole/pages/publish_post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/profile.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/ui.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  static const String route = '/match';

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  late List<Profile> _pals;
  Profile? _pal;

  @override
  void initState() {
    super.initState();
    _fetchMatchedPals().then((_) => _setPal());
  }

  Future<void> _fetchMatchedPals() async {
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    try {
      _pals = await RepositoryProvider.of<ProfileRepository>(context)
          .fetchMatchedPals(id);
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error fetch matched user');
    } catch (e) {
      context.showErrorSnackbar('Error fetch matched user');
    }
  }

  void _setPal() {
    Profile pal = _pals.isEmpty
        ? Profile.emptyProfile
        : _pals[Random().nextInt(_pals.length)];
    setState(() {
      _pal = pal;
    });
  }

  Widget _buildMatchResult() {
    final pal = _pal;
    if (pal == null) {
      return const Loading();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: pal.isEmpty()
                ? null
                : () => goUserIntroductionPage(
                      context,
                      Profile(
                        id: pal.id,
                        username: pal.username,
                        avatarUrl: pal.avatarUrl,
                      ),
                    ),
            child: CircleAvatar(
              radius: 102 / 2,
              child: CircleAvatar(
                radius: 96 / 2,
                backgroundColor: Theme.of(context).backgroundColor,
                backgroundImage:
                    NetworkImage(pal.avatarUrl ?? defaultAvatarUrl),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            pal.username,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: pal.isEmpty()
                    ? () => Navigator.of(context).pushNamed(AddPostPage.route)
                    : _setPal,
                child: Text(
                  pal.isEmpty() ? 'Go publish more posts~' : 'Another one',
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 48),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Match Your Pal'),
            Expanded(child: _buildMatchResult()),
          ],
        ),
      ),
    );
  }
}
