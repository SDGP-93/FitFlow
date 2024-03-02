import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'home.dart';

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
        title: Text('Settings'),
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
                  return DeleteAccountDialog();
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homePage()),
          );
        },
        child: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class DeleteAccountDialog extends StatefulWidget {
  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Account"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are you sure you want to delete your account?"),
          SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Enter your email'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Enter your password'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            // Validate email and password before proceeding
            if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter your email and password.'),
                ),
              );
              return;
            }

            // Delete account only if email matches
            try {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // Re-authenticate user to confirm deletion
                AuthCredential credential = EmailAuthProvider.credential(email: _emailController.text.trim(), password: _passwordController.text);
                await user.reauthenticateWithCredential(credential);

                // Delete account
                await user.delete();

                // Navigate to startup page and refresh
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              }
            } catch (error) {
              print('Error deleting account: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete account. Please try again.'),
                ),
              );
            }
          },
          child: Text("Delete"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
