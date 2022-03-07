import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/pie.dart';
import 'package:treehole/models/emotion.dart';
import 'package:treehole/repositories/profile.dart';

Future<void> goEmotionPage(BuildContext context, String userId) {
  return Navigator.of(context).pushNamed(EmotionPage.route, arguments: userId);
}

class EmotionPage extends StatefulWidget {
  const EmotionPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  static const String route = '/emotion';

  @override
  State<EmotionPage> createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
  Emotion _emotion =
      Emotion(joy: 20, mild: 20, disgust: 20, depressed: 20, anger: 20);

  void _fetchUserEmotion() async {
    final emotion = await RepositoryProvider.of<ProfileRepository>(context)
        .fetchUserEmotion(widget.userId);
    setState(() {
      _emotion = emotion;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserEmotion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Emotion'),
            Expanded(child: Pie(emotion: _emotion)),
          ],
        ),
      ),
    );
  }
}
