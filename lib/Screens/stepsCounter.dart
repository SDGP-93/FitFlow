import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'common_navbar.dart';

void main() {
  runApp(MaterialApp(
    home: StepCountPage(),
  ));
}

class StepCountPage extends StatefulWidget {
  @override
  _StepCountPageState createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  int _stepCount = 0;
  double _distanceTravelled = 0.0;
  bool _isListening = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  List<double> _accelerometerValues = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    super.dispose();
    _stopListening();
  }

  void _startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
        _checkForStep();
      });
    });

    setState(() {
      _isListening = true;
    });

    _startGPS();
  }

  void _stopListening() {
    _accelerometerSubscription?.cancel();
    setState(() {
      _isListening = false;
    });
    _stopGPS();
  }

  void _checkForStep() {
    final double currentAccelerationMagnitude = _accelerometerValues.fold(0, (previous, current) => previous + current.abs());
    final double threshold = 11.0; // Adjust this threshold according to your device and sensitivity
    if (currentAccelerationMagnitude > threshold) {
      setState(() {
        _stepCount++;
      });
    }
  }

  void _startGPS() {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10, // meters
    ).listen((Position position) {
      // You can calculate distance travelled here
      setState(() {
        _distanceTravelled = _distanceTravelled + position.speed! * 0.277778 * 10; // Speed * time interval (1 sec) * 10
      });
    });
  }

  void _stopGPS() {
    // Stop GPS tracking
  }

  void _updateFirestore() {
    // Update Firestore collection with user's data
    FirebaseFirestore.instance.collection('StepCount').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'sensorCount': _stepCount,
      'distanceTravelled': _distanceTravelled,
      'stepCount': calculateSteps(_distanceTravelled),
      'caloriesBurned': calculateCaloriesBurnt(calculateSteps(_distanceTravelled), _distanceTravelled),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/stepBg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 170),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sensor Count: $_stepCount',
                  style: TextStyle(fontSize: 12), // Small text
                  textAlign: TextAlign.center, // Align center
                ),
                SizedBox(height: 00),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'DISTANCE WALKED ${_distanceTravelled.toStringAsFixed(2)} .m',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center, // Align center
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'STEPS  ${calculateSteps(_distanceTravelled)}',
                  style: TextStyle(fontSize: 48), // Big text
                  textAlign: TextAlign.center, // Align center
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Text(
                    'Calories Burnt ♨️\n ${calculateCaloriesBurnt(calculateSteps(_distanceTravelled), _distanceTravelled).toStringAsFixed(2)} .kal',
                    style: TextStyle(fontSize: 18,color: Colors.white),
                    textAlign: TextAlign.center, // Align center
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 50,
                  height: 50, // Ensure width and height are equal
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(85), // Half of the width/height
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
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
                    onPressed: _isListening ? _stopListening : _startListening,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(85), // Half of the width/height
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                    ),
                    child: Text(
                      _isListening ? 'Stop' : 'Start',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  width: 170,
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
                    onPressed: _updateFirestore,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                    ),
                    child: Text(
                      'Update Workout Plan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int calculateSteps(double distance) {
  // Ratio: 5 steps for every 25 meters
  double ratio = 5 / 25;
  int steps = (distance * ratio).toInt();
  return steps;
}

double calculateCaloriesBurnt(int calculateSteps, double distance) {
  // Calories burnt per step
  double caloriesPerStep = 0.04;

  // Calculate total calories burnt based on steps and distance
  double totalCaloriesBurnt = calculateSteps * caloriesPerStep + (distance / 25) * caloriesPerStep * 5;

  return totalCaloriesBurnt;
}
