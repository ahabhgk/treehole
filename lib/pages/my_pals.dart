import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/pal.dart';
import 'package:treehole/components/retry.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/introduction.dart';
import 'package:treehole/repositories/follow.dart';
import 'package:treehole/utils/ui.dart';
import 'package:treehole/pages/introduction.dart';

Future<void> goMyPalsPage(BuildContext context, String userId) {
  return Navigator.of(context).pushNamed(MyPalsPage.route, arguments: userId);
}

class MyPalsPage extends StatefulWidget {
  const MyPalsPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  static const String route = '/pals';

  @override
  _MyPalsPageState createState() => _MyPalsPageState();
}

class _MyPalsPageState extends State<MyPalsPage> {
  late Future<List<Profile>> _pals;

  @override
  void initState() {
    super.initState();
    _loadMyPals();
  }

  void _loadMyPals() {
    _pals = RepositoryProvider.of<FollowRepository>(context)
        .fetchPalsProfileByUserId(widget.userId);
  }

  Widget _buildPals() {
    return FutureBuilder<List<Profile>>(
      future: _pals,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pals = snapshot.data;
          if (pals!.isEmpty) {
            return const Center(child: Text('Go find some pals~'));
          }
          return ListView.separated(
            itemCount: pals.length,
            separatorBuilder: (context, index) => const Divider(
              height: 2,
              indent: 12,
              endIndent: 12,
            ),
            itemBuilder: (context, index) {
              final e = pals[index];
              return PalWidget(
                username: e.username,
                avatarUrl: e.avatarUrl,
                onTap: () => goUserIntroductionPage(
                  context,
                  Profile(
                    id: e.id,
                    username: e.username,
                    avatarUrl: e.avatarUrl,
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Retry(onRetry: _loadMyPals);
        } else {
          return const Loading();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Pals'),
            Expanded(child: _buildPals()),
          ],
        ),
      ),
    );
  }
}
