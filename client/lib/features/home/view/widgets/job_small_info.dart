import 'package:flutter/material.dart';

class JobSmallInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  JobSmallInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white),

        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}
