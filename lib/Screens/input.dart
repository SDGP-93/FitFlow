import 'package:flutter/material.dart';

void main() {
  runApp(input());
}

class input extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('User Input Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedWeightOption,
              onChanged: (newValue) {
                setState(() {
                  _selectedWeightOption = newValue!;
                });
              },
              items: <String>[
                'Skinny',
                'Underweight',
                'Regular',
                'Muscular',
                'Overweight',
                'Obese'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Weight',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (in cm)',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Gender:'),
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
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Level:'),
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
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to MyWorkoutPlanPage
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
