import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Figma-logo.svg/1365px-Figma-logo.svg.png',
        ),
        title: Text('Google', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Our reviewer has gone through.....'),
        trailing: Column(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text('2', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 5),
            Text('14:45'),
          ],
        ),
      ),
    );
  }
}
