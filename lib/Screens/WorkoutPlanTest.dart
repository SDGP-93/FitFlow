import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_navbar.dart';

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
      Uri.parse('http://10.31.1.90:5000/generate_workout'),
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
          padding: EdgeInsets.fromLTRB(20, 65, 20, 10),
          child: Column(
            children: [
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter calories required'),
              ),
              SizedBox(height: 15),
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
                      'SHOW WORKOUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _saveWorkoutToFirestore,
                child: Text(
                  'Save Workout',
                  style: TextStyle(
                    color: Colors.teal,
                  ),
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
