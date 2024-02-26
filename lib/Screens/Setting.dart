import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(FitFlowApp());
}

class DarkThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(bool newValue) {
    _isDarkMode = newValue;
    notifyListeners();
  }
}

class FitFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkThemeProvider(),
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'FitFlow',
            theme: themeProvider.isDarkMode
                ? ThemeData.dark()
                : ThemeData.light(),
            home: SettingsPage(),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            trailing: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleDarkMode(value);
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text('Feedback'),
            onTap: () {
              // Implement feedback logic
            },
          ),
          ListTile(
            title: Text('Change Password'),
            onTap: () {
              // Implement change password logic
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Implement logout logic
              Navigator.pop(context); // Navigate back to previous screen
            },
          ),
          ListTile(
            title: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Implement delete account logic
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Delete Account"),
                    content: Text("Are you sure you want to delete your account?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement delete account logic here
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}