import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 36,
          margin: const EdgeInsets.all(12),
          child: child,
        ),
        const Divider(height: 2),
      ],
    );
  }
}
