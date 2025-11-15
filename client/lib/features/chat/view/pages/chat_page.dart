import 'package:flutter/material.dart';
import 'package:jobnexus/features/chat/view/widgets/chat_card.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(tabs: [Tab(text: 'Chats'), Tab(text: 'Calls')]),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return ChatCard();
              },
            ),
            Center(child: Text('Calls')),
          ],
        ),
      ),
    );
  }
}
