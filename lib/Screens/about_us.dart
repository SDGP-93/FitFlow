import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart'; // Import the url_launcher package

class FitflowHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent default back button behavior
        return false;
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close the page when tapped
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            fit: StackFit.expand, // Make the Stack fill the entire screen
            children: [
              // Background Image
              Image.asset(
                'assets/aboutBg.png',
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0), // Adjust as needed
                    // Fitflow Logo
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0),
                      child: Image.asset(
                        'assets/logo.png',
                        width: MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    // Social Media Icons
                    GridView.count(
                      crossAxisCount: 2, // 2 items per row
                      shrinkWrap: true,
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
                      crossAxisSpacing: MediaQuery.of(context).size.width * 0.1,
                      mainAxisSpacing: MediaQuery.of(context).size.width * 0,
                      children: [
                        buildSocialMediaIcon('assets/insta.png', 'https://www.instagram.com/fitflow.app_?igsh=Z250bzBld2llY2hj'),
                        buildSocialMediaIcon('assets/fb.png', 'https://www.instagram.com/ecom__worldz/?igsh=M296ZGF5NnN4NzM5'),
                        buildSocialMediaIcon('assets/tele.png', 'https://www.instagram.com/ecom__worldz/?igsh=M296ZGF5NnN4NzM5'),
                        buildSocialMediaIcon('assets/x.png', 'mailto:fitflowsnsf@gmail.com'), // Modified to open email client
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Adjust spacing between the grid and bottom edge
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Additional space to prevent boxes from touching the bottom edge
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05, // Adjust the position as needed
                right: MediaQuery.of(context).size.width * 0.45, // Adjust the position as needed
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => homePage()),
                    );// Close the page when tapped
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back, color: Colors.teal), // Close icon
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSocialMediaIcon(String imagePath, String url) {
    return GestureDetector(
      onTap: () {
        if (url.startsWith('mailto:')) {
          launch(url);
        } else {
          launch(url); // Launch the provided URL when tapped
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FitflowHistoryPage(),
  ));
}
