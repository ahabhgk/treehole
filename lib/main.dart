import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treehole/pages/tabs.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/signup.dart';
import 'package:treehole/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const homeRoute = '/';
  static const loginRoute = '/login';
  static const signupRoute = '/signup';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'treehole',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      initialRoute: loginRoute,
      routes: <String, WidgetBuilder>{
        homeRoute: (context) => const TabsPage(),
        loginRoute: (context) => const LoginPage(),
        signupRoute: (context) => const SignupPage(),
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppTheme.backgroundColor,
      primaryColor: AppTheme.primaryColor,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: AppTheme.textColor,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        border: OutlineInputBorder(),
      ),
      visualDensity: VisualDensity.standard,
    );
  }
}
