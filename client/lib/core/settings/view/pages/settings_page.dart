import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Account Settings
            SizedBox(height: 24),

            // Notifications
            _buildSection(
              title: 'Notifications',
              icon: Iconsax.notification,
              children: [
                _buildSwitchItem(
                  icon: Iconsax.notification,
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _buildSwitchItem(
                  icon: Iconsax.sms,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 24),

            // App Preferences
            _buildSection(
              title: 'Preferences',
              icon: Iconsax.setting,
              children: [
                _buildSettingsItem(
                  icon: Iconsax.language_circle,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items:
                        ['English', 'Spanish', 'French', 'German'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                    underline: SizedBox(),
                  ),
                ),
                _buildSwitchItem(
                  icon: Iconsax.moon,
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 24),

            // Support
            _buildSection(
              title: 'Support',
              icon: Iconsax.support,
              children: [
                _buildSettingsItem(
                  icon: Iconsax.message_question,
                  title: 'Help & Support',
                  subtitle: 'Get help with the app',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Iconsax.info_circle,
                  title: 'About',
                  subtitle: 'App version 1.0.0',
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 32),

            // Logout Button
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showLogoutDialog,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.red),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue[700]),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.blue[700]),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing:
          trailing ??
          Icon(Iconsax.arrow_right_3, size: 18, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.blue[700]),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[700],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Log Out'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement logout logic
                },
                child: Text('Log Out', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
