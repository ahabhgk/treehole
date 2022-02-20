import 'package:flutter/material.dart';

class Retry extends StatelessWidget {
  const Retry({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).errorColor,
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
