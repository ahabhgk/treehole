import 'package:flutter/material.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/tabs.dart';

extension ShowSnackBar on BuildContext {
  /// Extention method to easily display snack bar.
  void showSnackbar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }

  /// Extention method to easily display error snack bar.
  void showErrorSnackbar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(this).errorColor),
      ),
    ));
  }
}

void redirectToLogin(BuildContext context) {
  Navigator.pushReplacementNamed(context, LoginPage.route);
}

void redirectToTabs(BuildContext context) {
  Navigator.pushReplacementNamed(context, TabsPage.route);
}

List<Widget> withDivider(List<Widget> children) {
  final List<Widget> res = children.fold(
    [],
    (acc, cur) => [
      ...acc,
      cur,
      const Divider(height: 2, indent: 12, endIndent: 12),
    ],
  )..removeLast();
  return res;
}
