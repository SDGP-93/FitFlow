import 'package:auth3/Screens/Setting.dart';
import 'package:auth3/Screens/profile_page.dart';
import 'package:auth3/Screens/username_display_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth3/Screens/about_us.dart';
import 'package:auth3/Screens/home.dart';
import 'package:auth3/Screens/logIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CommonNavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const CommonNavBar({Key? key, this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the home page when the back button is pressed
        Navigator.pushReplacementNamed(context, 'home');
        return false; // Prevents default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.teal.withOpacity(0.5),
          elevation: 3,
          shadowColor: Colors.teal,
          toolbarHeight: 40,
          leading: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true, // Ensures the bottom sheet starts from the top
                      builder: (BuildContext context) {
                        return Container(
                            alignment: Alignment.topRight, // Align to the right edge
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.tealAccent, Colors.teal], // Gradient colors: white to teal
                        ),
                        ),// Adjust the width as needed
                        child: Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                                  // Fetch user profile image URL from Firestore
                                  StreamBuilder<User?>(
                                    stream: FirebaseAuth.instance.authStateChanges(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                                        return SizedBox();
                                      }
                                      String userId = snapshot.data!.uid;
                                      return FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance.collection('profiles').doc(userId).get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                                            return SizedBox();
                                          }
                                          String? profileImage = (snapshot.data!.data() as Map<String, dynamic>?)?['profileImage'];
                                          return profileImage != null
                                              ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(profileImage),
                                          )
                                              : SizedBox(height: 40);
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: 80),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => UsernamePage()),
                                      );
                                    },
                                    icon: Icon(Icons.ad_units_rounded),
                                    label: Text('Username'),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProfilePage()),
                                      );
                                    },
                                    icon: Icon(Icons.account_circle),
                                    label: Text('Profile'),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => FitFlowApp()),
                                      );
                                    },
                                    icon: Icon(Icons.settings),
                                    label: Text('Settings'),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => homePage()),
                                      );
                                    },
                                    icon: Icon(Icons.home),
                                    label: Text('Home'),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => FitflowHistoryPage()),
                                      );
                                    },
                                    icon: Icon(Icons.directions_run),
                                    label: Text('Fitflow'),
                                  ),
                                  SizedBox(height: 10),
                                  IconButton(
                                    onPressed: onBackPressed,
                                    icon: Icon(Icons.check_circle_outline, color: Colors.teal),
                                  ),
                                  SizedBox(height: 50),
                                  IconButton(
                                    onPressed: () {
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
                                    icon: Icon(Icons.logout, color: Colors.white), // Logout button
                                  ),
                                ],
                              ),
                            ),
                          ),
                            ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
          // Add the background image to the app bar
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/appbarBG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, IconData icon, void Function()? onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

void main() {
  runApp(CommonNavBar());
}