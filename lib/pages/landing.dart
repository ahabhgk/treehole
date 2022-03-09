import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/services/user.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/ui.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  static const String route = '/landing';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoad) {
          redirectToLogin(context);
        } else if (state is UserLoaded) {
          redirectToTabs(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 132),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  appName,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    recoverSession();
  }

  void recoverSession() {
    BlocProvider.of<UserCubit>(context).recover();
  }
}
