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
                child: PopupMenuButton(
                  shape: null,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 40,
                  ),
                  color: Colors.transparent,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.75),
                              Colors.teal.withOpacity(0.75),
                              Colors.white.withOpacity(0.75),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end, // Align items to the right
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
                                      radius: 20,
                                      backgroundImage: AssetImage(profileImage),
                                    )
                                        : SizedBox();
                                  },
                                );
                              },
                            ),
                            buildMenuItem(context, 'Username', Icons.ad_units_rounded, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UsernamePage()),
                              );
                            }),
                            buildMenuItem(context, 'Profile', Icons.account_circle, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage()),
                              );
                            }),
                            buildMenuItem(context, 'Settings', Icons.settings, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FitFlowApp()),
                              );
                            }),
                            buildMenuItem(context, 'Home', Icons.home, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => homePage()),
                              );
                            }),
                            buildMenuItem(context, 'Fitflow', Icons.directions_run, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FitflowHistoryPage()),
                              );
                            }),
                            SizedBox(height: 8),
                            IconButton(
                              onPressed: onBackPressed,
                              icon: Icon(Icons.check_circle_outline, color: Colors.teal),
                            ),
                            SizedBox(height: 8),
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
                              icon: Icon(Icons.logout, color: Colors.red), // Logout button
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    // Handle menu item selection here
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
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(10, (1 - value) * 30),
            child: child,
          ),
        );
      },
      child: TextButton(
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
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

