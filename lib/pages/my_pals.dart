import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/pal.dart';
import 'package:treehole/components/retry.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/follow.dart';
import 'package:treehole/utils/ui.dart';

class MyPalsPage extends StatefulWidget {
  const MyPalsPage({Key? key}) : super(key: key);

  static const String route = '/my_pals';

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
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    _pals = RepositoryProvider.of<FollowRepository>(context)
        .fetchPalsProfileByUserId(id);
  }

  Widget _buildPals() {
    return FutureBuilder<List<Profile>>(
      future: _pals,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pals = snapshot.data!
              .map((e) => PalWidget(
                    username: e.username,
                    avatarUrl: e.avatarUrl,
                  ))
              .toList();
          return ListView(children: withDivider(pals));
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
            const Header(
              child: Text(
                'My Pals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: _buildPals()),
          ],
        ),
      ),
    );
  }
}
