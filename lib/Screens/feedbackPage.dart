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
    return Scaffold(

      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CommonNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 120, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide Your Feedback',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
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
            SizedBox(height: 30.0),
            Text(
              'Rate Our Service',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Row(
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
                    ),
                  ),
              ],
            ),
            SizedBox(height: 40.0),
            Text(
              'Any issues encountered while using the app',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
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
            SizedBox(height: 40),
            Center(
              child: Container(
                width: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.black],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal,
                      offset: Offset(0, 2),
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
                      vertical: 5,
                      horizontal: 3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _submitFeedback();
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
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50), // Add spacing below the button
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
                  size: 24,
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
