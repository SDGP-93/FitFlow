import 'package:auth3/Screens/SavedWorkoutPage.dart';
import 'package:auth3/Screens/TDEE_Test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'Setting.dart';
import 'common_navbar.dart';
import 'feedbackPage.dart';
import 'input.dart';
import 'stepsCounter.dart';
import 'about_us.dart';
import 'weight_input_page.dart';

class homePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    // Disable back button press for Android
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CommonNavBar(),
        body: Container(
          decoration: BoxDecoration(
            gradient: _isDarkMode ? darkGradient : lightGradient,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(70.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: kToolbarHeight + 0,
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30.0,
                          crossAxisSpacing: 40.0,
                          shrinkWrap: true,
                          children: [
                            buildButton(context, '', 'assets/db.png', () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              // Wait for 2 seconds
                              await Future.delayed(Duration(seconds: 2)); // Adjust the duration as needed

                              // Navigate to input page
                              Navigator.pop(context); // Close loading indicator
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BMRPage()),
                              );
                            }),
                            buildButton(context, '', 'assets/cal3.png', () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              // Wait for 1 or 2 seconds
                              await Future.delayed(Duration(seconds: 1)); // Adjust the duration as needed
                              // Navigate to input page
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StepCountPage()));
                            }),
                            buildButton(context, '', 'assets/pro2.png', () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              // Wait for 1 or 2 seconds
                              await Future.delayed(Duration(seconds: 1)); // Adjust the duration as needed
                              // Navigate to input page
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WeightInputPage()));
                            }),
                            buildButton(context, '', 'assets/logo.png', () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              // Wait for 1 or 2 seconds
                              await Future.delayed(Duration(seconds: 1)); // Adjust the duration as needed
                              // Navigate to input page
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FitflowHistoryPage()));
                            }),
                            buildButton(context, '', 'assets/set.png', () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              // Wait for 1 or 2 seconds
                              await Future.delayed(Duration(seconds: 1)); // Adjust the duration as needed
                              // Navigate to input page
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FitFlowApp()));
                            }),
                            buildButton(context, '', 'assets/feed.png', () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              // Wait for 1 or 2 seconds
                              await Future.delayed(Duration(seconds: 1)); // Adjust the duration as needed
                              // Navigate to input page
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
                            }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'SORE NOW.\nSTRONG FOREVER.',
                            style: TextStyle(
                              fontSize: 25,
                              color: _isDarkMode ? Colors.tealAccent : Colors.white24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('info')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Center(
                              child: Text(
                                'Update Your Username',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          } else {
                            String? username =
                            snapshot.data!.get('username');
                            return Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: _isDarkMode ? Colors.black : Colors.teal,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _isDarkMode ? Colors.tealAccent : Colors.black, // Adjust shadow color if needed
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${username ?? 'Not available'}',
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.tealAccent : Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                // Navigate to the FeedbackPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedWorkoutsPage()),
                );
              },
              backgroundColor: Colors.black,
              mini: true,
              child: Icon(
                Icons.fitness_center,
                color: Colors.teal,
              ),
            ),
            FloatingActionButton(
              onPressed: toggleTheme,
              backgroundColor: Colors.black,
              mini: true,
              child: Icon(
                Icons.light_mode,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String tag, String backgroundImage,
      VoidCallback onTap) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
      transform: Matrix4.identity()..scale(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        boxShadow: _isDarkMode
            ? [
          BoxShadow(
            color: Colors.tealAccent,
            spreadRadius: 1.5,
            blurRadius: 10.0,
            offset: Offset(0, 0),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.teal,
            spreadRadius: 0.5,
            blurRadius: 3.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          highlightColor: Colors.teal.withOpacity(0.5),
          splashColor: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.0),
          child: Center(
            child: Text(
              tag,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final lightGradient = LinearGradient(
  colors: [Colors.white,Colors.white, Colors.teal],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final darkGradient = LinearGradient(
  colors: [Colors.black,Colors.black12, Colors.teal],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

void main() {
  runApp(homePage());
}