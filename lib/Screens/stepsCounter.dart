import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'common_navbar.dart';
import 'home.dart';

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
  double _screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStoredData();
    _startListening();
  }

  @override
  void dispose() {
    super.dispose();
    _stopListening();
  }

  void _loadStoredData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('StepCount').doc(user.uid).get();
        if (snapshot.exists) {
          setState(() {
            _stepCount = snapshot['sensorCount'];
            _distanceTravelled = snapshot['distanceTravelled'];
          });
        }
      } catch (error) {
        print('Error loading stored data: $error');
      }
    }
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
      setState(() {
        _distanceTravelled = _distanceTravelled + position.speed! * 0.277778 * 10; // Speed * time interval (1 sec) * 10
      });
    });
  }

  void _stopGPS() {
    // Stop GPS tracking
  }

  void _updateFirestore() {
    FirebaseFirestore.instance.collection('StepCount').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'sensorCount': _stepCount,
      'distanceTravelled': _distanceTravelled,
      'stepCount': calculateSteps(_distanceTravelled),
      'caloriesBurned': calculateCaloriesBurnt(calculateSteps(_distanceTravelled), _distanceTravelled),
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/stepBg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 230),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sensor Rate $_stepCount',
                  style: TextStyle(fontSize: _screenWidth * 0.025), // Adjust text size based on screen width
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _screenWidth * 0.01),
                Container(
                  padding: EdgeInsets.all(_screenWidth * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_screenWidth * 0.1),
                  ),
                  child: Text(
                    'DISTANCE WALKED ${_distanceTravelled.toStringAsFixed(2)} .m',
                    style: TextStyle(fontSize: _screenWidth * 0.040, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: _screenWidth * 0.07),
                Text(
                  'STEPS  ${calculateSteps(_distanceTravelled)}',
                  style: TextStyle(fontSize: _screenWidth * 0.08),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _screenWidth * 0.04),
                Container(
                  padding: EdgeInsets.all(_screenWidth * 0.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_screenWidth * 0.02),
                    gradient: LinearGradient(
                      colors: [Colors.cyan, Colors.tealAccent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    'Calories Burnt ♨️\n ${calculateCaloriesBurnt(calculateSteps(_distanceTravelled), _distanceTravelled).toStringAsFixed(2)} .kal',
                    style: TextStyle(fontSize: _screenWidth * 0.045, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: _screenWidth * 0.14),
                Container(
                  width: _screenWidth * 0.16,
                  height: _screenWidth * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_screenWidth * 0.17), // Make it a circle
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _isListening ? _stopListening : _startListening,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(_screenWidth * 0.03),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_screenWidth * 0.17), // Make it a circle
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                    ),
                    child: Text(
                      _isListening ? 'Stop' : 'Start',
                      style: TextStyle(fontSize: _screenWidth * 0.035, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: _screenWidth * 0.19),
                Container(
                  width: _screenWidth * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_screenWidth * 0.09),
                    gradient: LinearGradient(
                      colors: [Colors.cyan, Colors.tealAccent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
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
                    onPressed: _updateFirestore,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(_screenWidth * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_screenWidth * 0.1),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Update Workout Plan',
                      style: TextStyle(fontSize: _screenWidth * 0.035, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: _screenWidth * 0.04), // Add spacing below the button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => homePage()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back, // Use any icon you prefer
                    color: Colors.teal,
                    size: _screenWidth * 0.06,
                  ),
                ),
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
