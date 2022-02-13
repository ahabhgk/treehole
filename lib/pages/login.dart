import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/pages/tabs.dart';
import 'package:treehole/pages/signup.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/utils/ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      final auth = RepositoryProvider.of<AuthenticationRepository>(context);
      final session = await auth.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      auth.setSession(session);
      redirectToTabs(context);
    } on PlatformException catch (err) {
      context.showErrorSnackbar(err.message ?? 'Error loging in');
    } catch (err) {
      context.showErrorSnackbar('Error loging in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 132),
            Container(
              alignment: Alignment.center,
              child: Image.asset('assets/treehole.png'),
            ),
            const SizedBox(height: 36),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SignupPage.route);
                  },
                  child: Text(' Sign up'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
