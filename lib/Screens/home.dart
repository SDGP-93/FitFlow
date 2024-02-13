import 'package:flutter/material.dart';
import 'common_navbar.dart';
/*import 'input.dart';
import 'stepcounter.dart';
import 'progress_tracking.dart';
import 'about_us.dart';
import 'settings.dart';
import 'feedback.dart';*/

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Set this to true to extend the body behind the app bar
      appBar: CommonNavBar(),
      body: Stack(
        children: [
          // Background Image
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
                    height: kToolbarHeight + 0, // Adjust as per your requirement
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
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => InputPage()));
                        }),
                        buildButton(context, '', 'assets/cal3.png', () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => StepCounterPage()));
                        }),
                        buildButton(context, '', 'assets/pro2.png', () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressTrackingPage()));
                        }),
                        buildButton(context, '', 'assets/logo.png', () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));
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
                        'Sore Now.\n'
                            'Strong Forever.', // Title text placeholder, replace with actual title
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white24,
                        ),
                        textAlign: TextAlign.center, // Center text horizontally
                      ),
                    ),
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
    home: HomePage(),
  ));
}