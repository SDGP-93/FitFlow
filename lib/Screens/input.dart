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
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homeBg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'CREATE YOUR PLAN',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 24,
                  color: Colors.teal, // Set text color to green
                ),
              ),
              SizedBox(height: 20),
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
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (int.tryParse(value ?? '') == null) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Gender:', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedGender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    items: <String>['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Level:', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedLevelOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLevelOption = newValue!;
                      });
                    },
                    items: <String>['Beginner', 'Mid', 'Pro'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
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
        child: Text('This is your workout plan.'),
      ),
    );
  }
}
