import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class JobList extends StatelessWidget {
  final String title;
  final String applications;
  final Color color;
  final String status;
  final VoidCallback? onDismissed;
  final Key dismissibleKey; // Important for Dismissible

  const JobList({
    super.key,
    required this.title,
    required this.applications,
    required this.status,
    required this.color,
    this.onDismissed,
    required this.dismissibleKey,
  });

  @override
  Widget build(BuildContext context) {
    // The main content remains exactly the same
    Widget content = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF6E75FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.briefcase,
                color: Color(0xFF6E75FF),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF110e48),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$applications applications',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Wrap with Dismissible if onDismissed callback is provided
    if (onDismissed != null) {
      return Dismissible(
        key:
            dismissibleKey ??
            Key(title), // Use provided key or generate from title
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Iconsax.trash, color: Colors.white, size: 24),
        ),
        confirmDismiss: (direction) async {
          // Optional: Show confirmation dialog
          final bool? confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Job?"),
                content: Text("Are you sure you want to delete '$title'?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
          return confirm ?? false;
        },
        onDismissed: (direction) {
          onDismissed!();
        },
        child: content,
      );
    }

    return content;
  }
}
