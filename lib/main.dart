import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/pages/emotion.dart';
import 'package:treehole/pages/introduction.dart';
import 'package:treehole/pages/match.dart';
import 'package:treehole/pages/my_likes.dart';
import 'package:treehole/pages/my_pals.dart';
import 'package:treehole/pages/publish_post.dart';
import 'package:treehole/pages/landing.dart';
import 'package:treehole/pages/my_posts.dart';
import 'package:treehole/pages/settings.dart';
import 'package:treehole/pages/tabs.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/signup.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/follow.dart';
import 'package:treehole/repositories/notification.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/repositories/profile.dart';
import 'package:treehole/repositories/storage.dart';
import 'package:treehole/services/counts.dart';
import 'package:treehole/services/feed.dart';
import 'package:treehole/services/found.dart';
import 'package:treehole/services/publish_post.dart';
import 'package:treehole/services/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANNON_KEY'),
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
    return _buildProvider(
      child: _buildView(),
    );
  }

  Widget _buildProvider({required Widget child}) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(
            supabaseClient: _supabaseClient,
            localStorage: _localStorage,
          ),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(
            supabaseClient: _supabaseClient,
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
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(
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
              profileRepo: RepositoryProvider.of<ProfileRepository>(context),
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
            ),
          ),
          BlocProvider<FoundCubit>(
            create: (context) => FoundCubit(
              authRepo:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              postRepo: RepositoryProvider.of<PostRepository>(context),
            ),
          ),
        ],
        child: child,
      ),
    );
  }

  Widget _buildView() {
    return MaterialApp(
      title: 'treehole',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'JBMono',
        colorScheme: const ColorScheme(
          primary: Color(0xFF388E3C),
          secondary: Color(0xFF26A69A),
          surface: Color(0xFFD4F081),
          background: Color(0xFFEAEEF2),
          error: Color(0xFFB00020),
          onPrimary: Color(0xffffffff),
          onSecondary: Color(0xffffffff),
          onSurface: Color(0xff000000),
          onBackground: Color.fromARGB(255, 60, 60, 60),
          onError: Color(0xffffffff),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'JBMono',
        colorScheme: const ColorScheme(
          primary: Color(0xFFBB86FC),
          secondary: Color(0xFF03DAC6),
          surface: Color(0xFF121212),
          background: Color(0xFF121212),
          error: Color(0xFFCF6679),
          onPrimary: Color(0xffffffff),
          onSecondary: Color(0xffffffff),
          onSurface: Color(0xff000000),
          onBackground: Color.fromARGB(255, 220, 220, 220),
          onError: Color(0xffffffff),
          brightness: Brightness.dark,
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
              builder: (context) =>
                  MyPostsPage(userId: settings.arguments as String),
              settings: settings,
            );
          case MyPalsPage.route:
            return MaterialPageRoute<void>(
              builder: (context) =>
                  MyPalsPage(userId: settings.arguments as String),
              settings: settings,
            );
          case MyLikesPage.route:
            return MaterialPageRoute<void>(
              builder: (context) =>
                  MyLikesPage(userId: settings.arguments as String),
              settings: settings,
            );
          case EmotionPage.route:
            return MaterialPageRoute<void>(
              builder: (context) =>
                  EmotionPage(userId: settings.arguments as String),
              settings: settings,
            );
          case MatchPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const MatchPage(),
              settings: settings,
            );
          case SettingsPage.route:
            return MaterialPageRoute<void>(
              builder: (context) => const SettingsPage(),
              settings: settings,
            );
          case IntroductionPage.route:
            return MaterialPageRoute<void>(
              builder: (context) {
                final profile = settings.arguments as Profile;
                return BlocProvider<CountsCubit>(
                  create: (context) => CountsCubit(
                    authRepo: RepositoryProvider.of<AuthenticationRepository>(
                        context),
                    postRepo: RepositoryProvider.of<PostRepository>(context),
                    followRepo:
                        RepositoryProvider.of<FollowRepository>(context),
                    userId: profile.id,
                  ),
                  child: IntroductionPage(profile: profile),
                );
              },
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
