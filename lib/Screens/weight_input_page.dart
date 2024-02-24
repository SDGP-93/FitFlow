import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'common_navbar.dart';

class WeightInputPage extends StatefulWidget {
@override
_WeightInputPageState createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  final TextEditingController _weightController = TextEditingController();
  String _selectedWeek = 'Week 1'; // Initial week value
  List<String> _weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Week 7'];
  List<Map<String, dynamic>> _weightData = [];

  @override
  void initState() {
    super.initState();
    _retrieveWeightData();
  }

  Future<void> _retrieveWeightData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user != null) {
      final String uid = user.uid;

      try {
        QuerySnapshot weightSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('weightData')
            .get();

        setState(() {
          _weightData = weightSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          // Remove weeks already selected
          _weeks = _weeks.where((week) => !_weightData.any((data) => data['week'] == week)).toList();
          // Check if the selected week is still available
          if (!_weeks.contains(_selectedWeek)) {
            // If not, select the first available week
            _selectedWeek = _weeks.isNotEmpty ? _weeks.first : '';
          }
        });
      } catch (error) {
        print('Failed to retrieve weight data: $error');
      }
    }
  }

  void _submitData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user != null) {
      final String uid = user.uid;
      final String weight = _weightController.text;
      final String week = _selectedWeek;

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('weightData')
            .add({'week': week, 'weight': weight});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Weight data added successfully')));
        _retrieveWeightData(); // Refresh weight data after adding new entry
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add weight data: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: SingleChildScrollView(
        child: Container(
          // Use MediaQuery to get the screen size and fill the available space
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/homeBG2.jpg'), // Background image
              fit: BoxFit.cover, // Cover the whole container
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 100, 40, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 40, // Set the desired height
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.yellow),
                    decoration: InputDecoration(
                      labelText: 'Weight (in kg)',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Add spacing between the widgets
                SizedBox(
                  height: 50, // Set the desired height
                  child: DropdownButtonFormField<String>(
                    value: _selectedWeek,
                    items: _weeks.map((week) {
                      return DropdownMenuItem<String>(
                        value: week,
                        child: Text(
                          week,
                          style: TextStyle(color: Colors.yellow),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedWeek = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Week',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.cyan),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 5,
                    shadowColor: Colors.cyan,
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  height: 250, // Set the desired height
                  child: _weightData.isNotEmpty
                      ? CustomGraph(weightData: _weightData.map((data) => data.cast<String, String>()).toList())
                      : Center(
                    child: Text('No weight data available'),
                  ),
                ),
                SizedBox(height: 30),
                LatestWeightMessage(weightData: _weightData.map((data) => data.cast<String, String>()).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGraph extends StatelessWidget {
  final List<Map<String, String>> weightData;

  CustomGraph({required this.weightData});

  @override
  Widget build(BuildContext context) {
    // Sort the weightData list based on the week number
    weightData.sort((a, b) {
      int weekA = int.parse(a['week']!.replaceAll(RegExp(r'[^0-9]'), ''));
      int weekB = int.parse(b['week']!.replaceAll(RegExp(r'[^0-9]'), ''));
      return weekA.compareTo(weekB);
    });

    List<FlSpot> spots = [FlSpot(0, 0)]; // Add the starting point (0, 0)
    double highestWeight = double.parse(weightData.first['weight']!);
    double lowestWeight = double.parse(weightData.first['weight']!);

    // Find the highest and lowest weights
    for (int i = 0; i < weightData.length; i++) {
      double weight = double.parse(weightData[i]['weight']!);
      if (weight > highestWeight) {
        highestWeight = weight;
      }
      if (weight < lowestWeight) {
        lowestWeight = weight;
      }
      spots.add(FlSpot(i.toDouble() + 1, weight));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10), // Adjust the padding as needed
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: spots.map((spot) {
                if (spot.y == highestWeight) {
                  return Colors.red; // Set color to red for highest weight dot
                } else if (spot.y == lowestWeight) {
                  return Colors.green; // Set color to green for lowest weight dot
                } else {
                  return Colors.yellow; // Default color for other dots
                }
              }).toList(),
              dotData: FlDotData(show: true), // Show dots
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 10,
              getTextStyles: (value) => const TextStyle(
                color: Colors.white,
                fontSize: 5,
              ),
              getTitles: (value) {
                if (value == 0) {
                  return '';
                }
                return weightData[(value - 1).toInt()]['week']!;
              },
              margin: 0,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 5,
              getTextStyles: (value) => const TextStyle(
                color: Colors.white,
                fontSize: 5,
              ),
              getTitles: (value) {
                return value.toString();
              },
              margin: 10,
            ),
          ),
          gridData: FlGridData(show: false), // Hide gridlines
        ),
      ),
    );
  }
}

class LatestWeightMessage extends StatelessWidget {
  final List<Map<String, String>> weightData;

  LatestWeightMessage({required this.weightData});

  @override
  Widget build(BuildContext context) {
    if (weightData.isNotEmpty) {
      double latestWeight = double.parse(weightData.last['weight']!);
      String message = '';

      if (latestWeight < -35) {
        message = 'Skinny';
      } else if (latestWeight >= -35 && latestWeight < 35) {
        message = 'Average';
      } else if (latestWeight >= 35 && latestWeight < 45) {
        message = 'Regular';
      } else if (latestWeight >= 45 && latestWeight < 60) {
        message = 'Good';
      } else if (latestWeight >= 60 && latestWeight < 70) {
        message = 'Overweight';
      } else if (latestWeight >= 70 && latestWeight < 90) {
        message = 'Obese';
      } else {
        message = 'Extremely Obese';
      }

      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Current Weight: ${latestWeight.toStringAsFixed(2)} kg\nCondition: $message',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return SizedBox(); // Return an empty container if weight data is empty
    }
  }
}
