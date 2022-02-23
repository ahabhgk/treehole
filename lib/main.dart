import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/pages/my_pals.dart';
import 'package:treehole/pages/publish_post.dart';
import 'package:treehole/pages/landing.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/pages/tabs.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/signup.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/follow.dart';
import 'package:treehole/repositories/like.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/repositories/profile.dart';
import 'package:treehole/services/counts.dart';
import 'package:treehole/services/feed.dart';
import 'package:treehole/services/found.dart';
import 'package:treehole/services/publish_post.dart';
import 'package:treehole/services/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://koavouexzdgkqdkeasfr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTY0NDE1NzYzNywiZXhwIjoxOTU5NzMzNjM3fQ.j68uq9PnvYAPxNY5H4xBh3o6UBwuPzFauvTCjVOH6Rs',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _supabaseClient = Supabase.instance.client;
  final _localStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    // _localStorage.deleteAll();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(
            supabaseClient: _supabaseClient,
            localStorage: _localStorage,
          ),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(
            supabaseClient: _supabaseClient,
          ),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(
            supabaseClient: _supabaseClient,
          ),
        ),
        RepositoryProvider<FollowRepository>(
          create: (context) => FollowRepository(
            supabaseClient: _supabaseClient,
          ),
        ),
        RepositoryProvider<LikeRepository>(
          create: (context) => LikeRepository(
            supabaseClient: _supabaseClient,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(
              authRepo:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              profileRepo: RepositoryProvider.of<ProfileRepository>(context),
            ),
          ),
          BlocProvider<PublishPostCubit>(
            create: (context) => PublishPostCubit(
              authRepo:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              postRepo: RepositoryProvider.of<PostRepository>(context),
            ),
          ),
          BlocProvider<CountsCubit>(
            create: (context) => CountsCubit(
              authRepo:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              postRepo: RepositoryProvider.of<PostRepository>(context),
              followRepo: RepositoryProvider.of<FollowRepository>(context),
            ),
          ),
          BlocProvider<FeedCubit>(
            create: (context) => FeedCubit(
              authRepo:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              postRepo: RepositoryProvider.of<PostRepository>(context),
              likeRepo: RepositoryProvider.of<LikeRepository>(context),
            ),
          ),
          BlocProvider<FoundCubit>(
            create: (context) => FoundCubit(
              authRepo:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              postRepo: RepositoryProvider.of<PostRepository>(context),
              likeRepo: RepositoryProvider.of<LikeRepository>(context),
            ),
          ),
        ],
        child: _buildView(context),
      ),
    );
  }

  Widget _buildView(BuildContext context) {
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
      initialRoute: LandingPage.route,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LandingPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const LandingPage(),
              settings: settings,
            );
          case TabsPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const TabsPage(),
              settings: settings,
            );
          case MyPostsPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const MyPostsPage(),
              settings: settings,
            );
          case MyPalsPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const MyPalsPage(),
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
