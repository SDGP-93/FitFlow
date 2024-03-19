import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'WorkoutPlanTest.dart';
import 'common_navbar.dart';

class BMRPage extends StatefulWidget {
  @override
  _BMRPageState createState() => _BMRPageState();
}

class _BMRPageState extends State<BMRPage> {
  TextEditingController _genderController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  int? _selectedActivityLevel; // Add this variable to store the selected activity level

  // Options for the activity level dropdown
  List<String> _activityLevelOptions = [
    '1 - Sedentary (little to no exercise)',
    '2 - Lightly active (light exercise)',
    '3 - Moderately active (moderate exercise)',
    '4 - Very active (hard exercise)',
    '5 - Extra active (very hard exercise)'
  ];
  String _predictedBMR = '';
  String _tdee = '';
  int _caloriesBurned = 0;
  int caloriesToBeBurned = 0;

  String? _genderError;
  String? _weightError;

  Future<void> _fetchCaloriesBurned() async {
    try {
      // Fetch caloriesBurned from Firestore collection "StepCount" for logged-in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('StepCount')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            _caloriesBurned = snapshot.data()?['caloriesBurned']?.toInt() ?? 0;
            // Update caloriesToBeBurned
            caloriesToBeBurned = _caloriesBurned;
          });
        }
      }
    } catch (error) {
      print('Error fetching caloriesBurned: $error');
    }
  }

  Future<void> _calculateBMR() async {
    if (_genderController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _selectedActivityLevel == null) {
      // Handle the case when any of the input fields are empty
      setState(() {
        _genderError = _genderController.text.isEmpty ? 'Please enter your gender' : null;
        _weightError = _weightController.text.isEmpty ? 'Please enter your weight' : null;
      });
      return;
    }

    // Validate gender
    if (!['male', 'female'].contains(_genderController.text.toLowerCase())) {
      setState(() {
        _genderError = 'Gender should be either male or female';
      });
      return;
    }

    // Validate weight
    if (int.tryParse(_weightController.text) == null) {
      setState(() {
        _weightError = 'Weight should be a valid number';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.31.1.90:5000/calculate_bmr'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'gender': _genderController.text,
        'weight': double.parse(_weightController.text),
        'activity_level': _selectedActivityLevel, // Use the selected activity level directly
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _predictedBMR = data['predicted_bmr'].toString();
        _tdee = data['tdee'].toString().replaceAll(RegExp(r'[^0-9.]'), ''); // Remove non-numeric characters
        // Update calories burned after BMR calculation
        _fetchCaloriesBurned();
        _genderError = null;
        _weightError = null;
      });

      // Save data to Firestore
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('BMR-TDEE').doc(user.uid).set({
            'gender': _genderController.text,
            'weight': double.parse(_weightController.text),
            'activity_level': _selectedActivityLevel,
            'predicted_bmr': _predictedBMR,
            'tdee': _tdee,
            'calories_to_be_burned': caloriesToBeBurned,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      } catch (error) {
        print('Error saving data to Firestore: $error');
      }
    } else {
      throw Exception('Failed to calculate BMR');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCaloriesBurned();
  }

  @override
  Widget build(BuildContext context) {
    int tdeeValue = 0;
    if (_tdee.isNotEmpty) {
      // Remove square brackets if present
      String cleanTDEE = _tdee.replaceAll(RegExp(r'[^\d.]'), '');
      // Parse the cleaned string as a double
      tdeeValue = double.tryParse(cleanTDEE)?.toInt() ?? 0;
    }
    int bmrValue = 0;
    if (_predictedBMR.isNotEmpty) {
      // Remove square brackets if present
      String cleanBMR = _predictedBMR.replaceAll(RegExp(r'[^\d.]'), '');
      // Parse the cleaned string as a double
      bmrValue = double.tryParse(cleanBMR)?.toInt() ?? 0;
    }
    caloriesToBeBurned = tdeeValue - bmrValue - _caloriesBurned;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bmrtdeeBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 80, 10, 20),
          child: Column(
            children: [
              TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: 'Enter Sex (male/female)',
                  errorText: _genderError,
                ),
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter weight (kg)',
                  errorText: _weightError,
                ),
              ),
              DropdownButtonFormField<int>(
                value: _selectedActivityLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedActivityLevel = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select activity level',
                ),
                items: List.generate(_activityLevelOptions.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1, // Index starts from 0, so add 1
                    child: Text(_activityLevelOptions[index]),
                  );
                }),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _calculateBMR,
                child: Text('Calculate BMR'),
              ),
              SizedBox(height: 60),
              Text(
                'Basal Metabolic Rate(BMR) \n$_predictedBMR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Total Daily Energy Expenditure(TDEE) \n$_tdee',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Predicted Calorie Goal\n $caloriesToBeBurned',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 80),
              Center(
                child: Container(
                  width: 200,
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
                        vertical: 15,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _predictedBMR.isEmpty
                        ? null
                        : () {
                      Navigator.pop(context); // Close the current page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WorkoutPage()),
                      );
                    },
                    child: Text(
                      'Generate Workout Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
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
    home: BMRPage(),
  ));
}
