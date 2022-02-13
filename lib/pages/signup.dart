import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/utils/ui.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  static const String route = '/signup';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  void _onSignup() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final auth = RepositoryProvider.of<AuthenticationRepository>(context);
      await auth.signup(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      context.showSnackbar('Register success. Please login.');
      redirectToLogin(context);
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      context.showErrorSnackbar(err.message ?? 'Error signing up');
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      context.showErrorSnackbar('Error signing up');
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
            const SizedBox(height: 120),
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
            const SizedBox(height: 12),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _isLoading ? null : _onSignup,
              child: _isLoading
                  ? const Text('Loading...')
                  : const Text('Register'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, SignupPage.route);
                  },
                  child: const Text(' Login'),
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
