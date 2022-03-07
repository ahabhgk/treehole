import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/models/profile.dart';
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
  Profile? _pal;

  @override
  void initState() {
    super.initState();
    _fetchMatchedPal();
  }

  Future<void> _fetchMatchedPal() async {
    setState(() {
      _pal = null;
    });
    final id =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    try {
      final pal = await RepositoryProvider.of<ProfileRepository>(context)
          .fetchMatchedPal(id);
      setState(() {
        _pal = pal;
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error fetch matched user');
    } catch (e) {
      context.showErrorSnackbar('Error fetch matched user');
    }
  }

  Future<void> _requestToBePal() async {
    Navigator.of(context).pop();
    context.showSnackbar('Request has been sent...');
  }

  Widget _buildMatchResult() {
    if (_pal == null) {
      return const Loading();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 102 / 2,
            child: CircleAvatar(
              radius: 96 / 2,
              backgroundColor: Theme.of(context).backgroundColor,
              backgroundImage:
                  NetworkImage(_pal?.avatarUrl ?? defaultAvatarUrl),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _pal!.username,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: _fetchMatchedPal,
                child: const Text('Another one'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _requestToBePal,
                child: const Text('Request to be pals'),
              ),
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
