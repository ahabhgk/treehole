import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treehole/pages/addPost.dart';
import 'package:treehole/pages/tabs.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/signup.dart';
import 'package:treehole/pages/tabs/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const tabsRoute = TabsPage.route;
  static const loginRoute = LoginPage.route;
  static const signupRoute = SignupPage.route;
  static const addPostRoute = AddPostPage.route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'treehole',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme(
          primary: Color(0xFF388E3C),
          primaryVariant: Color(0xFF2D7230),
          secondary: Color(0xFF26A69A),
          secondaryVariant: Color(0xFF1E857B),
          surface: Color(0xFFD4F081),
          background: Color(0xFFEAEEF2),
          error: Color(0xFFB00020),
          onPrimary: Color(0xffffffff),
          onSecondary: Color(0xffffffff),
          onSurface: Color(0xff000000),
          onBackground: Color(0xffffffff),
          onError: Color(0xffffffff),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme(
          primary: Color(0xFFBB86FC),
          primaryVariant: Color(0xFF3700B3),
          secondary: Color(0xFF03DAC6),
          secondaryVariant: Color(0xFF03DAC6),
          surface: Color(0xFF121212),
          background: Color(0xFF121212),
          error: Color(0xFFCF6679),
          onPrimary: Color(0xffffffff),
          onSecondary: Color(0xffffffff),
          onSurface: Color(0xff000000),
          onBackground: Color(0xffffffff),
          onError: Color(0xffffffff),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: loginRoute,
      routes: <String, WidgetBuilder>{
        tabsRoute: (context) => const TabsPage(),
        loginRoute: (context) => const LoginPage(),
        signupRoute: (context) => const SignupPage(),
        addPostRoute: (context) => const AddPostPage(),
      },
    );
  }
}
