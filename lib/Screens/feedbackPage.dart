import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'common_navbar.dart';
import 'home.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  String _feedback = '';
  String _issues = '';

  Future<void> _submitFeedback() async {
    // Get the current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Store feedback data in Firestore
    try {
      await FirebaseFirestore.instance.collection('UserFeedback').doc(userId).set({
        'feedback': _feedback,
        'rating': _rating,
        'issues': _issues,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Feedback submitted successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the page
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error submitting feedback: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CommonNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _screenWidth * 0.05, vertical: _screenWidth * 0.3), // Adjust top and horizontal padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide Your Feedback',
              style: TextStyle(fontSize: _screenWidth * 0.05, fontWeight: FontWeight.bold), // Adjust font size
            ),
            SizedBox(height: _screenWidth * 0.02),
            TextFormField(
              maxLines: 5,
              maxLength: 250,
              decoration: InputDecoration(
                hintText: 'Enter your feedback (max 250 words)',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Border color when the field is enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal), // Border color when the field is focused
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _feedback = value;
                });
              },
            ),
            SizedBox(height: _screenWidth * 0.05),
            Text(
              'Rate Our Service',
              style: TextStyle(fontSize: _screenWidth * 0.05, fontWeight: FontWeight.bold), // Adjust font size
            ),
            SizedBox(height: _screenWidth * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = i;
                      });
                    },
                    child: Icon(
                      _rating >= i ? Icons.star : Icons.star_border,
                      color: Colors.teal,
                      size: _screenWidth * 0.1, // Adjust icon size
                    ),
                  ),
              ],
            ),
            SizedBox(height: _screenWidth * 0.05),
            Text(
              'Any issues encountered while using the app',
              style: TextStyle(fontSize: _screenWidth * 0.05, fontWeight: FontWeight.bold), // Adjust font size
            ),
            SizedBox(height: _screenWidth * 0.02),
            TextFormField(
              maxLines: 3,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Enter any issues (max 100 words)',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Border color when the field is enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal), // Border color when the field is focused
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _issues = value;
                });
              },
            ),
            SizedBox(height: _screenWidth * 0.05),
            Center(
              child: Container(
                width: _screenWidth * 0.6, // Adjust button width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.tealAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: _screenWidth * 0.015, // Adjust vertical padding
                      horizontal: _screenWidth * 0.03, // Adjust horizontal padding
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _submitFeedback();
                    // Removed showDialog here as it's already called inside _submitFeedback
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _screenWidth * 0.04, // Adjust font size dynamically
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: _screenWidth * 0.1), // Adjust spacing
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => homePage()), // Navigate to startup page
                  );
                },
                child: Icon(
                  Icons.arrow_back, // Use any icon you prefer
                  color: Colors.teal,
                  size: _screenWidth * 0.06, // Adjust icon size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedbackPage(),
  ));
}
