import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'common_navbar.dart';
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

  void refreshPage(BuildContext context) {
    Navigator.pop(context); // Close the current page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CommonNavBar(onBackPressed: () => refreshPage(context)),
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
                            buildButton(context, '', 'assets/db.png', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => input()));
                            }),
                            buildButton(context, '', 'assets/cal3.png', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StepCounterCircle()));
                            }),
                            buildButton(context, '', 'assets/pro2.png', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WeightInputPage()));
                            }),
                            buildButton(context, '', 'assets/logo.png', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FitflowHistoryPage()));
                            }),
                            buildButton(context, '', 'assets/set.png', () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                            }),
                            buildButton(context, '', 'assets/feed.png', () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
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
                              color: Colors.white24,
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
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black, // Adjust shadow color if needed
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${username ?? 'Not available'}',
                                  style: TextStyle(
                                    color: Colors.white,
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
        floatingActionButton: FloatingActionButton(
          onPressed: toggleTheme,
          backgroundColor: Colors.black,
          mini: true,
          child: Icon(
            Icons.light_mode,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String tag, String backgroundImage,
      VoidCallback onTap) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
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
  colors: [Colors.black,Colors.black, Colors.teal],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

void main() {
  runApp(homePage());
}