import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/services/user.dart';
import 'package:treehole/utils/ui.dart';
import 'package:treehole/utils/validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  static const String route = '/signup';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<UserCubit>(context).signup(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoad) {
          context.showSnackbar('Register success. Please login.');
          redirectToLogin(context);
        } else if (state is UserError) {
          context.showErrorSnackbar(state.message);
        }
      },
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
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
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: Validator.username,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: Validator.email,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: Validator.password,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (val) {
                    final valid = Validator.password(val);
                    if (valid != null) return valid;
                    if (val != _passwordController.text) {
                      return 'Password is not matching.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: state is UserSigningUp ? null : _onSignup,
                  child: Text(
                      state is UserSigningUp ? 'Signing up...' : 'Register'),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
