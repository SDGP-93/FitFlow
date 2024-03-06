import 'package:flutter/cupertino.dart';
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
  String _selectedLevelOption = 'sedentary';
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

  double calculate_bmr(int age, int weight, int height, String gender) {
    if (gender.toLowerCase() == 'male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else if (gender.toLowerCase() == 'female') {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    } else {
      throw ArgumentError("Invalid gender! Please Enter your gender as 'male' or 'female'.");
    }
  }

  double calculate_tdee(double bmr, String activity_level) {
    Map<String, double> activity_multipliers = {
      'sedentary': 1.2,
      'lightly active': 1.375,
      'moderately active': 1.55,
      'very active': 1.725,
      'extra active': 1.9
    };

    if (activity_multipliers.containsKey(activity_level.toLowerCase())) {
      return bmr * activity_multipliers[activity_level.toLowerCase()]!;
    } else {
      throw ArgumentError("Invalid activity level! Please enter correctly.");
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
                        _selectedLevelOption = 'sedentary';
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'sedentary' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/begBtn.png'),
                    ),
                  ),
                  SizedBox(width: 0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'lightly active';
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'lightly active' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/midBtn.png'),
                    ),
                  ),
                  SizedBox(width: 0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'moderately active';
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'moderately active' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/proBtn.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'very active';
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'very active' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/midBtn.png'),
                    ),
                  ),
                  SizedBox(width: 00),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevelOption = 'extra active';
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _selectedLevelOption == 'extra active' ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/midBtn.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Center(
                child: Container(
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
                    onPressed: _isButtonDisabled ? null : () async {
                      final age = int.tryParse(_ageController.text) ?? 0;
                      final weight = int.tryParse(_weightController.text) ?? 0;
                      final height = int.tryParse(_heightController.text) ?? 0;

                      final bmr = calculate_bmr(age, weight, height, _selectedGender);
                      final tdee = calculate_tdee(bmr, _selectedLevelOption);

                      final inputData = {
                        'age': age.toString(),
                        'weight': weight.toString(),
                        'height': height.toString(),
                        'gender': _selectedGender,
                        'level': _selectedLevelOption,
                        'bmr': bmr.toString(),
                        'tdee': tdee.toString(),
                      };

                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('InputSubmit')
                              .doc(currentUser.uid)
                              .set(inputData);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyWorkoutPlanPage(bmr, tdee),
                            ),
                          );
                        } catch (error) {
                          print('Error storing input data: $error');
                        }
                      }
                    },
                    child: Text('Submit',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: ''
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

class MyWorkoutPlanPage extends StatelessWidget {
  final double bmr;
  final double tdee;

  MyWorkoutPlanPage(this.bmr, this.tdee);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bmrBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 180, 10, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your BMR',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${bmr.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                    ),
                    SizedBox(height: 170),
                    Text(
                      'Your TDEE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${tdee.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 120),
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
                        vertical: 15,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );*/
                    },
                    child: Text(
                      'Generate Workout Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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