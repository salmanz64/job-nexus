import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CandidateNotf extends StatefulWidget {
  const CandidateNotf({Key? key}) : super(key: key);

  @override
  State<CandidateNotf> createState() => _CandidateNotfState();
}

class _CandidateNotfState extends State<CandidateNotf> {
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Application Viewed',
      description:
          'TechCorp Inc. has viewed your application for Senior Flutter Developer',
      time: 'Just now',
      icon: Iconsax.eye,
      iconColor: Colors.blue,
      isRead: false,
      type: NotificationType.application,
    ),
    NotificationItem(
      id: '2',
      title: 'New Job Match',
      description:
          'Mobile Developer position at StartupXYZ matches your profile',
      time: '10 min ago',
      icon: Iconsax.briefcase,
      iconColor: Colors.green,
      isRead: false,
      type: NotificationType.jobMatch,
    ),
    NotificationItem(
      id: '3',
      title: 'Interview Scheduled',
      description:
          'Your interview with TechCorp has been scheduled for Dec 20, 2024 at 2:00 PM',
      time: '1 hour ago',
      icon: Iconsax.calendar,
      iconColor: Colors.orange,
      isRead: true,
      type: NotificationType.interview,
    ),
    NotificationItem(
      id: '4',
      title: 'Application Status Update',
      description:
          'Your application for Product Manager has moved to the next round',
      time: '2 hours ago',
      icon: Iconsax.tick_circle,
      iconColor: Colors.green,
      isRead: true,
      type: NotificationType.application,
    ),
    NotificationItem(
      id: '5',
      title: 'Profile Viewed',
      description: '5 recruiters viewed your profile this week',
      time: '5 hours ago',
      icon: Iconsax.profile_2user,
      iconColor: Colors.purple,
      isRead: true,
      type: NotificationType.profile,
    ),
    NotificationItem(
      id: '6',
      title: 'Weekly Digest',
      description: 'Check out new jobs that match your skills',
      time: '1 day ago',
      icon: Iconsax.notification,
      iconColor: Colors.blue,
      isRead: true,
      type: NotificationType.digest,
    ),
    NotificationItem(
      id: '7',
      title: 'Reminder: Complete Profile',
      description: 'Complete your profile to get 50% more job matches',
      time: '2 days ago',
      icon: Iconsax.info_circle,
      iconColor: Colors.amber,
      isRead: true,
      type: NotificationType.reminder,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Iconsax.setting, color: Colors.grey[700]),
            onPressed: () {
              // Navigate to notification settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          _buildQuickActions(),
          SizedBox(height: 8),

          // Notifications List
          Expanded(
            child:
                notifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(notifications[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _markAllAsRead,
              icon: Icon(Iconsax.tick_circle, size: 16),
              label: Text('Mark all as read'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _clearAll,
              icon: Icon(Iconsax.trash, size: 16),
              label: Text('Clear all'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Iconsax.trash, color: Colors.red),
      ),
      onDismissed: (direction) {
        setState(() {
          notifications.removeWhere((item) => item.id == notification.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  notifications.insert(
                    notifications.indexWhere(
                      (item) => item.id == notification.id,
                    ),
                    notification,
                  );
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border:
              !notification.isRead
                  ? Border.all(color: Colors.blue[100]!, width: 1)
                  : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                size: 20,
                color: notification.iconColor,
              ),
            ),
            SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight:
                                notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification.time,
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.notification_bing,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'re all caught up! New notifications will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to jobs page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Browse Jobs'),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Clear All Notifications'),
            content: Text(
              'Are you sure you want to clear all notifications? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    notifications.clear();
                  });
                  Navigator.pop(context);
                },
                child: Text('Clear All', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}

// Notification Model
class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isRead,
    required this.type,
  });
}

enum NotificationType {
  application,
  jobMatch,
  interview,
  profile,
  digest,
  reminder,
}
