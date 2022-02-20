import 'package:flutter/material.dart';

class EmptyFiller extends StatelessWidget {
  const EmptyFiller({
    Key? key,
    this.onFindMore,
    required this.tips,
  }) : super(key: key);

  final void Function()? onFindMore;
  final String tips;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.explore),
          TextButton(
            onPressed: onFindMore,
            child: Text(tips),
          )
        ],
      ),
    );
  }
}
