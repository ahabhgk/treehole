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

class TitleHeader extends StatelessWidget {
  const TitleHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Header(
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BackHeader extends StatelessWidget {
  const BackHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Header(
      goBack: () => Navigator.of(context).pop(),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
