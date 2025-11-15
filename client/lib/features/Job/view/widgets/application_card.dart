import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Image.network(
            width: 25,
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Figma-logo.svg/1365px-Figma-logo.svg.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        'Ui/Ux Designer',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Figma'),
          SizedBox(height: 10),
          Container(
            width: 100,
            height: 20,

            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Application Sent',
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(Icons.navigate_next_rounded),
    );
  }
}
