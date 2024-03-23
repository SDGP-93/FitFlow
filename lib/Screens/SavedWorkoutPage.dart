import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'common_navbar.dart';

class SavedWorkoutsPage extends StatefulWidget {
  @override
  _SavedWorkoutsPageState createState() => _SavedWorkoutsPageState();
}

class _SavedWorkoutsPageState extends State<SavedWorkoutsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> _savedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _retrieveSavedWorkouts();
  }

  Future<void> _retrieveSavedWorkouts() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      CollectionReference savedWorkoutsCollection =
      _firestore.collection('users').doc(userId).collection('SavedWorkouts');

      try {
        QuerySnapshot querySnapshot = await savedWorkoutsCollection.get();
        List<dynamic> savedWorkouts =
        querySnapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          _savedWorkouts = savedWorkouts;
        });
      } catch (error) {
        print('Failed to retrieve saved workouts: $error');
      }
    }
  }

  Future<void> _removeWorkout(int index) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      CollectionReference savedWorkoutsCollection =
      _firestore.collection('users').doc(userId).collection('SavedWorkouts');

      try {
        await savedWorkoutsCollection.doc(_savedWorkouts[index]['id']).delete();
        setState(() {
          _savedWorkouts.removeAt(index);
        });
      } catch (error) {
        print('Failed to remove workout: $error');
      }
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.tealAccent,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.tealAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: Offset(2, 1),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'SETS',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '1 set means 1 day per week, if it\'s 3 sets, you should workout the given exercise 3 days per a week\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'REPS',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'count of the given workout',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '➲',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Adjust the spacing as needed
            Expanded(
              child: _savedWorkouts.isEmpty
                  ? Center(
                child: Text('NO WORKOUTS AVAILABLE'),
              )
                  : ListView.builder(
                itemCount: _savedWorkouts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> workout = _savedWorkouts[index];
                  return WorkoutCard(
                    exercise: workout['Exercise']?.toString() ?? '',
                    sets: workout['Sets']?.toString() ?? '',
                    reps: workout['Reps']?.toString() ?? '',
                    onComplete: () => _removeWorkout(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String exercise;
  final String sets;
  final String reps;
  final VoidCallback onComplete;

  const WorkoutCard({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.teal,
                ),
                SizedBox(width: 8),
                Text(
                  'Sets: $sets',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 8),
                Text(
                  'Reps: $reps',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onComplete,
                  child: Text(
                    'COMPLETE',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
