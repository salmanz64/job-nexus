import 'package:flutter/material.dart';
import 'package:jobnexus/core/constants/application_status_color.dart';

class ApplicationCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final Color color;
  final String status;
  final String? companyUrl;

  const ApplicationCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.color,
    required this.companyUrl,
  });

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            width: 25,
            companyUrl ??
                'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Figma-logo.svg/1365px-Figma-logo.svg.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(jobTitle, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(companyName),
          SizedBox(height: 10),
          Container(
            width: 100,
            height: 20,

            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Application $status',
                style: TextStyle(color: color, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(Icons.navigate_next_rounded),
    );
  }
}
