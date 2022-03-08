import 'package:flutter/material.dart';
import 'package:treehole/utils/constants.dart';

class PalWidget extends StatelessWidget {
  const PalWidget({
    Key? key,
    required this.username,
    required this.avatarUrl,
    this.onTap,
  }) : super(key: key);

  final String username;
  final String? avatarUrl; // null for default avatar
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36 / 2,
              backgroundImage: NetworkImage(avatarUrl ?? defaultAvatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                username,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
