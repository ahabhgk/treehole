import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key, this.child, this.goBack}) : super(key: key);

  final Widget? child;
  final void Function()? goBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: goBack,
              child: SizedBox(
                width: goBack != null ? 36 : 0,
                child: goBack != null
                    ? const Icon(Icons.arrow_back_ios_new)
                    : null,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 36,
                margin: const EdgeInsets.all(12),
                child: child,
              ),
            ),
            SizedBox(width: goBack != null ? 36 : 0),
          ],
        ),
        const Divider(height: 2),
      ],
    );
  }
}
