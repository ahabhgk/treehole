import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/components/loading.dart';
import 'package:treehole/components/notification.dart';
import 'package:treehole/components/pull_down.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/follow.dart';
import 'package:treehole/repositories/notification.dart';
import 'package:treehole/utils/ui.dart';
import 'package:treehole/models/notification.dart' as notification;

class NotificationTabPage extends StatefulWidget {
  const NotificationTabPage({Key? key}) : super(key: key);

  @override
  _NotificationTabPageState createState() => _NotificationTabPageState();
}

class _NotificationTabPageState extends State<NotificationTabPage> {
  List<notification.Notification>? _notifications;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadMyNotifications();
  }

  Future<void> _loadMyNotifications() async {
    final userId =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    try {
      final moreNotifications =
          await RepositoryProvider.of<NotificationRepository>(context)
              .fetchNotificationsByUserId(userId, _page);
      final notifications = (_notifications ?? [])..addAll(moreNotifications);
      final page = moreNotifications.isEmpty ? _page : _page + 1;
      setState(() {
        _notifications = notifications;
        _page = page;
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error fetch user notifications');
    } catch (e) {
      context.showErrorSnackbar('Error fetch user  notifications');
    }
  }

  void _follow(String followingId, String followedId) async {
    try {
      await RepositoryProvider.of<FollowRepository>(context)
          .followUser(followingId, followedId);
      final notifications = _notifications!
          .map((n) => notification.Notification(
                kind: n.kind,
                senderId: n.senderId,
                createdAt: n.createdAt,
                receiverId: n.receiverId,
                senderUsername: n.senderUsername,
                senderAvatarUrl: n.senderAvatarUrl,
                isFollowed: n.kind == notification.NotificationKind.follow &&
                        followingId == n.receiverId &&
                        followedId == n.senderId
                    ? true
                    : n.isFollowed,
              ))
          .toList();
      setState(() {
        _notifications = notifications;
      });
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error follow user');
    } catch (e) {
      context.showErrorSnackbar('Error follow user');
    }
  }

  Widget _buildNotifications() {
    final notifications = _notifications;
    if (notifications != null) {
      return PullDown(
        onLoadMore: _loadMyNotifications,
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return NotificationWidget(
            kind: n.kind,
            senderUsername: n.senderUsername,
            senderAvatarUrl: n.senderAvatarUrl,
            createdAt: n.createdAt,
            isFollowed: n.isFollowed,
            onAgreeTap: () => _follow(n.receiverId, n.senderId),
          );
        },
      );
    } else {
      return const Loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleHeader(title: 'Notifications'),
        Expanded(child: _buildNotifications()),
      ],
    );
  }
}
