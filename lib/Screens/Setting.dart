import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // Handle notification state changes
              },
            ),
          ),
          ListTile(
            title: Text(
              'Dark Mode',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                // Handle dark mode state changes
              },
            ),
          ),
          ListTile(
            title: Text(
              'Language',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white), // Set icon color to white
            onTap: () {
              // Navigate to language settings page or show a language picker dialog
            },
          ),
          ListTile(
            title: Text(
              'Feedback',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white), // Set icon color to white
            onTap: () {
              // Navigate to feedback page
            },
          ),
        ],
      ),
    );
  }
}