import 'package:flutter/material.dart';
import 'common_navbar.dart';
import 'input.dart';
import 'stepsCounter.dart';
import 'about_us.dart';
import 'weight_input_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class homePage extends StatelessWidget {
  void refreshPage(BuildContext context) {
    Navigator.pop(context); // Close the current page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(onBackPressed: () => refreshPage(context)),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/homeBG2.jpg',
              fit: BoxFit.cover,
            ),
          ),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => input()));
                        }),
                        buildButton(context, '', 'assets/cal3.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StepCounterCircle()));
                        }),
                        buildButton(context, '', 'assets/pro2.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WeightInputPage()));
                        }),
                        buildButton(context, '', 'assets/logo.png', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FitflowHistoryPage()));
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
                        'Sore Now.\nStrong Forever.',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('info').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(
                          child: Text(
                            'Update Your Username',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 10,
                            ),
                          ),
                        );
                      } else {
                        String? username = snapshot.data!.get('username');
                        return Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan, // Adjust shadow color if needed
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              '${username ?? 'Not available'}',
                              style: TextStyle(
                                color: Colors.yellow,
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
    );
  }

  Widget buildButton(
      BuildContext context,
      String tag,
      String backgroundImage,
      VoidCallback onTap,
      ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow,
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
          highlightColor: Colors.transparent,
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

void main() {
  runApp(MaterialApp(
    home: homePage(),
  ));
}
