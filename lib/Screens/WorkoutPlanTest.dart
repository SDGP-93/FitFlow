import 'dart:convert';
import 'package:auth3/Screens/TDEE_Test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_navbar.dart';
import 'home.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  TextEditingController _caloriesController = TextEditingController();
  List<dynamic> _workouts = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _generateWorkout() async {
    final response = await http.post(
      Uri.parse('https://9771-124-43-78-135.ngrok-free.app/generate_workout'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'calories_required': int.parse(_caloriesController.text),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _workouts = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load workout');
    }
  }

  Future<void> _saveWorkoutToFirestore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      CollectionReference savedWorkoutsCollection =
      _firestore.collection('users').doc(userId).collection('SavedWorkouts');

      // Fetch existing documents and delete them
      QuerySnapshot querySnapshot = await savedWorkoutsCollection.get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
      }

      // Add each workout to the collection
      _workouts.forEach((workout) async {
        await savedWorkoutsCollection.add(workout);
      });

      // Close the page after saving
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/workoutShowBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.05, screenWidth * 0.05, screenHeight * 0.02),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter calories required',
                  hintText: 'Enter the calculated calories to be burned', // Add this line for hint
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Container(
                width: screenWidth * 0.4,
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
                  onPressed: _generateWorkout,
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
                  child: Text(
                    'Show Workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.05),
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
                      child: ListTile(
                        title: Text(
                          _workouts[index]['Exercise'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Sets\t\t ${_workouts[index]['Sets']}\nReps\t ${_workouts[index]['Reps']}',
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Add functionality if needed
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              ElevatedButton(
                onPressed: () {
                  _saveWorkoutToFirestore();
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent users from dismissing the dialog
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(), // Show a loading indicator
                      );
                    },
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      // Update the state to close the loading dialog
                      Navigator.pop(context); // Close the loading dialog
                      Navigator.pop(context); // Close the current page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => homePage()));
                    });
                  });
                },
                child: Text(
                  'Save Workout',
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BMRPage()), // Navigate to startup page
                  );
                },
                child: Icon(
                  Icons.arrow_back, // Use any icon you prefer
                  color: Colors.teal,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WorkoutPage(),
  ));
}
