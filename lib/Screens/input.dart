import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'common_navbar.dart';

void main() {
  runApp(input());
}

class input extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Application',
      theme: ThemeData(
        primaryColor: Colors.blue,
        focusColor: Colors.cyanAccent,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
        ),
      ),
      home: UserInputPage(),
    );
  }
}

class UserInputPage extends StatefulWidget {
  @override
  _UserInputPageState createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  String _selectedLevelOption = 'Beginner';
  String _selectedGender = 'Male';
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_validateInputs);
    _heightController.addListener(_validateInputs);
    _weightController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    final age = int.tryParse(_ageController.text) ?? 0;
    final height = int.tryParse(_heightController.text) ?? 0;
    final weight = int.tryParse(_weightController.text) ?? 0;

    setState(() {
      _isButtonDisabled = !(age >= 15 && age <= 60 && height > 0 && weight > 0);
    });
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
            image: AssetImage('assets/inputBg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  final age = int.tryParse(value ?? '');
                  if (age == null || !(age >= 15 && age <= 60)) {
                    return 'Please enter a valid age (15-60)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (in kg)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (int.tryParse(value ?? '') == null) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (in cm)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
                style: TextStyle(color: Colors.teal),
                validator: (value) {
                  if (int.tryParse(value ?? '') == null) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Male';
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: _selectedGender == 'Male' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(75), // Make it circular
                      ),
                      child: Image.asset('assets/maleBtn.png'),
                    ),
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Female';
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: _selectedGender == 'Female' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(75), // Make it circular
                      ),
                      child: Image.asset('assets/femaleBtn.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'Beginner';
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'Beginner' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/begBtn.png'),
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'Mid';
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'Mid' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/midBtn.png'),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'Pro';
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'Pro' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/proBtn.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonDisabled ? null : () async {
                  // Prepare data to be stored in Firestore
                  Map<String, dynamic> inputData = {
                    'age': _ageController.text,
                    'weight': _weightController.text,
                    'height': _heightController.text,
                    'gender': _selectedGender,
                    'level': _selectedLevelOption,
                  };

                  // Get the current user
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    try {
                      // Store data in Firestore under 'InputSubmit' collection
                      await FirebaseFirestore.instance
                          .collection('InputSubmit')
                          .doc(currentUser.uid) // Use user's UID as document ID
                          .set(inputData);

                      // Navigate to MyWorkoutPlanPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyWorkoutPlanPage(),
                        ),
                      );
                    } catch (error) {
                      print('Error storing input data: $error');
                      // Handle error as needed
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyWorkoutPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workout Plan'),
      ),
      body: Center(
        child: Text('This is your new workout plan.'),
      ),
    );
  }
}