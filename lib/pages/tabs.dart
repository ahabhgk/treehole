import 'package:flutter/material.dart';
import 'package:treehole/pages/publish_post.dart';
import 'package:treehole/pages/tabs/found.dart';
import 'package:treehole/pages/tabs/feed.dart';
import 'package:treehole/pages/tabs/notification.dart';
import 'package:treehole/pages/tabs/profile.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  static const String route = '/';

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _tabIndex = 0;
  static const List<Widget> _tabs = <Widget>[
    FeedTabPage(),
    FoundTabPage(),
    NotificationTabPage(),
    ProfileTabPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, AddPostPage.route),
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: _tabs.elementAt(_tabIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
