import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobnexus/core/settings/view/pages/settings_page.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';
import 'package:jobnexus/features/applications/view/pages/application_page.dart';

import 'package:jobnexus/features/chat/view/pages/chat_page.dart';
import 'package:jobnexus/features/home/view/pages/home_page.dart';

import 'package:jobnexus/features/notification/view/pages/notification_page.dart';
import 'package:jobnexus/features/profile/view/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  final bool isRecruiter;
  MainPage({super.key, required this.isRecruiter});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(isRecruiter: widget.isRecruiter),
      ApplicationPage(isRecruiter: widget.isRecruiter),
      ChatPage(),
      ProfilePage(isRecruiter: widget.isRecruiter),
    ];
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          height: 20,
          width: 20,

          decoration: BoxDecoration(
            color: Color(0xFF6E75FF),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: GestureDetector(
            child: Center(child: Icon(Icons.person, color: Colors.white)),
          ),
        ),
        title: Center(
          child: Text('Jobs', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _selectedIndex != 3
                  ? Icons.notifications_active_outlined
                  : Icons.settings,
              size: 30,
            ),
            onPressed:
                () => {
                  _selectedIndex != 3
                      ? Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      )
                      : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      ),
                },
          ),
          SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Pallete.transparentColor,
        buttonBackgroundColor: Pallete.purpleColor,
        color: Pallete.purpleColor,
        animationCurve: Curves.ease,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.edit_document, size: 30, color: Colors.white),
          Icon(Icons.chat, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}
