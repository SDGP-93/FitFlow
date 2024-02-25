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

        // Refresh weight data after adding new entry
        _retrieveWeightData();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add weight data: $error')));
      }
    }
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

        List<Map<String, dynamic>> weightData = weightSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        setState(() {
          _weightData = weightData;
          // Sort weight data by week number
          _weightData.sort((a, b) => a['week'].compareTo(b['week']));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/weightBg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.fromLTRB(40, 100, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.teal),
                  decoration: InputDecoration(
                    labelText: 'WEIGHT (in KG)',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: DropdownButtonFormField<String>(
                  value: _selectedWeek,
                  items: _weeks.map((week) {
                    return DropdownMenuItem<String>(
                      value: week,
                      child: Text(
                        week,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedWeek = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'SELECT WEEK',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
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
                    onPressed: _submitData,
                    child: Text(
                      'DONE',
                      style: TextStyle(color: Colors.teal),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 5,
                      shadowColor: Colors.teal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 250,
                child: _weightData.isNotEmpty
                    ? CustomGraph(weightData: _weightData.map((data) => data.cast<String, String>()).toList())
                    : Center(
                  child: Text('No weight data available'),
                ),
              ),
              SizedBox(height: 80),
              LatestWeightMessage(weightData: _weightData.map((data) => data.cast<String, String>()).toList()),
            ],
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
          colors: [Colors.teal.withOpacity(0.5), Colors.black.withOpacity(0.5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
                  return Colors.yellow; // Set color to red for highest weight dot
                } else if (spot.y == lowestWeight) {
                  return Colors.white; // Set color to green for lowest weight dot
                } else {
                  return Colors.black; // Default color for other dots
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
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: false, // Hide top horizontal line
            drawVerticalLine: false, // Hide right vertical line
          ),
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
        message = '🧡: ★/5';
      } else if (latestWeight >= -35 && latestWeight < 35) {
        message = '🧡: ★★/5';
      } else if (latestWeight >= 35 && latestWeight < 45) {
        message = '💚: ★★★/5';
      } else if (latestWeight >= 45 && latestWeight < 60) {
        message = '💚: ★★★★/5';
      } else if (latestWeight >= 60 && latestWeight < 70) {
        message = '💚: ★★★★★/5';
      } else if (latestWeight >= 70 && latestWeight < 90) {
        message = '❤️: ★★★/5';
      } else {
        message = '💛: ★★/5';
      }

      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[300]!,
              Colors.grey[200]!,
            ],
            stops: [0.3, 0.9],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            'Current Weight: ${latestWeight.toStringAsFixed(2)} kg\nHealth Rate: $message',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return SizedBox(); // Return an empty container if weight data is empty
    }
  }
}
