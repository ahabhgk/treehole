import 'package:flutter/material.dart';
import 'package:treehole/models/notification.dart';
import 'package:treehole/utils/constants.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
    required this.kind,
    required this.senderUsername,
    required this.senderAvatarUrl,
    required this.createdAt,
    this.onAgreeTap,
    this.isFollowed,
  }) : super(key: key);

  final NotificationKind kind;
  final String senderUsername;
  final String? senderAvatarUrl; // null for default avatar
  final void Function()? onAgreeTap;
  final bool? isFollowed; // only for follow notifications
  final DateTime createdAt;

  String _buildTip() {
    if (kind == NotificationKind.follow) {
      if (isFollowed == true) {
        return 'becomes your pal!';
      }
      return 'requests to be pals with you~';
    }
    throw Exception('unreachable');
  }

  List<Widget> _buildButton(BuildContext context) {
    if (kind == NotificationKind.follow) {
      if (isFollowed != true) {
        return [
          OutlinedButton(
            onPressed: onAgreeTap,
            child: Text(
              'Agree',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ];
      } else {
        return [];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36 / 2,
                backgroundImage:
                    NetworkImage(senderAvatarUrl ?? defaultAvatarUrl),
              ),
              const SizedBox(width: 12),
              Text(
                senderUsername,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 48),
              Text(_buildTip()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ..._buildButton(context),
            ],
          )
        ],
      ),
    );
  }
}
