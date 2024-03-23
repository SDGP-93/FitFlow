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
          elevation: 5,
          shadowColor: Colors.cyan,
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
                    Icons.manage_accounts,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    // Custom animation for bottom sheet
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true, // Ensures the bottom sheet starts from the top
                      builder: (BuildContext context) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1, 0), // Start position (off-screen right)
                            end: Offset.zero, // End position (center of the screen)
                          ).animate(CurvedAnimation(
                            parent: ModalRoute.of(context)!.animation!,
                            curve: Curves.linearToEaseOut,
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/aboutBg2.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(// Use a Stack to overlap widgets
                                children: [
                            Transform.rotate(
                            angle: -90 * (3.14 / 180), // Convert degrees to radians
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'F I T F L O W',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight, // Align to the right edge
                            color: Colors.transparent, // Transparent background
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.cyan.withOpacity(0.5), Colors.tealAccent.withOpacity(0.7), Colors.teal.withOpacity(0.8)], // Gradient colors: white to teal
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                radius: 60,
                                                backgroundImage: AssetImage(profileImage),
                                              )
                                                  : SizedBox(height: 40);
                                            },
                                          );
                                        },
                                      ),
                                SizedBox(height: 80),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ), // Background color for the button
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => UsernamePage()),
                                            );
                                          },
                                          icon: Icon(Icons.ad_units_rounded, color: Colors.white),
                                          label: Text(
                                            'User',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                  ),
                                      ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),// Background color for the button
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProfilePage()),
                                            );
                                          },
                                          icon: Icon(Icons.account_circle, color: Colors.white),
                                          label: Text(
                                            'Profile',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                                  SizedBox(height: 40),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(30),
                                      ), // Background color for the button
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FitFlowApp()),
                                            );
                                          },
                                          icon: Icon(Icons.settings, color: Colors.white),
                                          label: Text(
                                            'Settings',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ), // Background color for the button
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => homePage()),
                                            );
                                          },
                                          icon: Icon(Icons.home, color: Colors.white),
                                          label: Text(
                                            'Home',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ), // Background color for the button
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FitflowHistoryPage()),
                                            );
                                          },
                                          icon: Icon(Icons.directions_run, color: Colors.white),
                                          label: Text(
                                            'Fitflow',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                      SizedBox(height: 20),
                                      // Add the button here
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the bottom sheet
                                        },
                                        icon: Icon(Icons.close), // Close icon
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ],
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