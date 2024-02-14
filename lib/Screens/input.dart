import 'package:flutter/material.dart';

void main() {
  runApp(Input());
}

class Input extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  String _selectedWeightOption = 'Regular';
  String _selectedLevelOption = 'Beginner';
  String _selectedGender = 'Male';
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/inputBG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWeightButton('Skinny'),
                      _buildWeightButton('Under\nWeight'),
                      _buildWeightButton('Regular'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWeightButton('Muscular'),
                      _buildWeightButton('Over\nWeight'),
                      _buildWeightButton('Obese'),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your age',
                      hintStyle: TextStyle(color: Colors.yellow),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: TextStyle(color: Colors.yellow),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height (in cm)',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your height',
                      hintStyle: TextStyle(color: Colors.yellow),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: TextStyle(color: Colors.yellow),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text('Gender:', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 80),
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
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text('Level:', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 80),
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
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyWorkoutPlanPage(),
                        ),
                      );
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightButton(String weightOption) {
    Color buttonColor = Colors.grey; // Default color

    // Set color based on weight option
    if (_selectedWeightOption == weightOption) {
      if (weightOption == 'Obese') {
        buttonColor = Colors.red; // Highlight red for obesity
      } else if (weightOption == 'Regular') {
        buttonColor = Colors.yellow; // Highlight yellow for regular
      } else if (weightOption == 'Skinny') {
        buttonColor = Colors.redAccent; // Highlight yellow for regular
      } else if (weightOption == 'Over\nWeight') {
        buttonColor = Colors.orange; // Highlight yellow for regular
      } else {
        buttonColor = Colors.cyan; // Default color for other options
      }
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedWeightOption = weightOption;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
          ),
          child: Center(
            child: Text(
              weightOption,
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
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