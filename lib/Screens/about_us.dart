import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

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
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo.png',
                      width: MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
                    ),
                  ),

                  SizedBox(height: 250),
                  // Social Media Icons
                  GridView.count(
                    crossAxisCount: 2, // 2 items per row
                    shrinkWrap: true,
                    padding: EdgeInsets.all(100),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    children: [
                      buildSocialMediaIcon('assets/insta.png', 'https://www.instagram.com/ecom__worldz/?igsh=M296ZGF5NnN4NzM5'),
                      buildSocialMediaIcon('assets/fb.png', 'https://www.instagram.com/ecom__worldz/?igsh=M296ZGF5NnN4NzM5'),
                      buildSocialMediaIcon('assets/tele.png', 'https://www.instagram.com/ecom__worldz/?igsh=M296ZGF5NnN4NzM5'),
                      buildSocialMediaIcon('assets/x.png', 'https://www.instagram.com/ecom__worldz/?igsh=M296ZGF5NnN4NzM5'),
                    ],
                  ),
                  SizedBox(height: 10), // Adjust spacing between the grid and bottom edge
                  SizedBox(height: 10), // Additional space to prevent boxes from touching the bottom edge
                ],
              ),
            ),
            Positioned(
              bottom: 20, // Adjust the position as needed
              right: 20, // Adjust the position as needed
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close the page when tapped
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5), // Adjust the background color and opacity as needed
                  child: Icon(Icons.close, color: Colors.white), // Close icon
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
        launch(url); // Launch the provided URL when tapped
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
  }}

void main() {
  runApp(MaterialApp(
    home: FitflowHistoryPage(),
  ));
}
