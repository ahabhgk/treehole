import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:treehole/pages/addPost.dart';
import 'package:treehole/pages/tabs.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'treehole',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme(
          primary: Color(0xFF388E3C),
          secondary: Color(0xFF26A69A),
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
          secondary: Color(0xFF03DAC6),
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
      themeMode: ThemeMode.system,
      initialRoute: LoginPage.route,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case TabsPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const TabsPage(),
              settings: settings,
            );
          case LoginPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const LoginPage(),
              settings: settings,
            );
          case SignupPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const SignupPage(),
              settings: settings,
            );
          case AddPostPage.route:
            return PageRouteBuilder<void>(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AddPostPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  fillColor: Theme.of(context).cardColor,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
