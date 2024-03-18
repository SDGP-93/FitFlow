import 'package:auth3/Screens/feedbackPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'common_navbar.dart';
import 'home.dart';
import 'logIn.dart';

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
                ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
            )
                : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.blue,
            ),
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
    return Scaffold( // Add Scaffold here
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Provider.of<DarkThemeProvider>(context).isDarkMode
                ? [Colors.black, Colors.black, Colors.teal]
                : [Colors.white, Colors.white, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
            ),
        ListTile(
          title: Text('Change Password'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ChangePasswordDialog();
              },
            );
          },
        ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Logout"),
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => logIn()),
                            );
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
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

  Future<void> deleteUserData(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final collections = ["InputSubmit", "StepCount", "profiles", "users", "info"];

      for (String collectionName in collections) {
        final collectionRef = firestore.collection(collectionName);
        final querySnapshot = await collectionRef.where('userId', isEqualTo: userId).get();

        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          // Remove the user's ID from the document
          final data = documentSnapshot.data() as Map<String, dynamic>;
          data.remove('userId');

          // Update the document without the user's ID
          await collectionRef.doc(documentSnapshot.id).set(data);
        }
      }
    } catch (error) {
      print('Error deleting user data: $error');
      throw error; // Rethrow the error for handling in the calling code
    }
  }

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

                // Delete user's collections
                await deleteUserData(user.uid);

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
class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController _newPasswordController = TextEditingController();
  bool _showConfirmation = false;

  @override
  Widget build(BuildContext context) {
    return _showConfirmation
        ? _buildConfirmationDialog()
        : _buildChangePasswordDialog();
  }

  Widget _buildChangePasswordDialog() {
    return AlertDialog(
      title: Text("Change Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Enter your new password'),
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
            try {
              String newPassword = _newPasswordController.text.trim();
              if (newPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a new password.'),
                  ),
                );
                return;
              }

              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await user.updatePassword(newPassword);
                setState(() {
                  _showConfirmation = true;
                });
              }
            } catch (error) {
              print('Error changing password: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to change password. Please try again.'),
                ),
              );
            }
          },
          child: Text("Change"),
        ),
      ],
    );
  }

  Widget _buildConfirmationDialog() {
    return AlertDialog(
      title: Text("Password Changed"),
      content: Text("Your password has been changed successfully."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }
}