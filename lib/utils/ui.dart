import 'package:flutter/material.dart';
import 'package:treehole/pages/login.dart';
import 'package:treehole/pages/tabs.dart';

extension ShowSnackBar on BuildContext {
  /// Extention method to easily display snack bar.
  void showSnackbar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(this).colorScheme.onPrimary),
      ),
    ));
  }

  /// Extention method to easily display error snack bar.
  void showErrorSnackbar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(this).colorScheme.error),
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
