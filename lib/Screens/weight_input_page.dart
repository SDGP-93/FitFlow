import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homeBG2.jpg'), // Background image
            fit: BoxFit.cover, // Cover the whole container
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.yellow),
                decoration: InputDecoration(labelText: 'Weight (in kg)',
                    labelStyle: TextStyle(color: Colors.white)),

              ),
              DropdownButtonFormField<String>(
                value: _selectedWeek,
                items: _weeks.map((week) {
                  return DropdownMenuItem<String>(
                    value: week,

                    child: Text(week,
                      style: TextStyle(color: Colors.yellow),),

                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedWeek = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Select Week',
                  labelStyle: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Done',
                  style: TextStyle(color: Colors.cyan),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button size smaller
                  elevation: 5, // Button bottom shadow
                  shadowColor: Colors.cyan, // Button bottom shadow color blue
                ),
              ),

              SizedBox(height: 20),
              Expanded(
                child: _weightData.isNotEmpty
                    ? charts.BarChart(
                  _createChartData(),
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  behaviors: [
                    charts.SeriesLegend(),
                  ],
                  defaultRenderer: charts.BarRendererConfig(
                    groupingType: charts.BarGroupingType.grouped,
                    strokeWidthPx: 2.0, // Bar border width
                    cornerStrategy: const charts.ConstCornerStrategy(30), // Bar corner radius
                    fillPattern: charts.FillPatternType.solid,
                  ),
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        color: charts.ColorUtil.fromDartColor(Colors.white), // X-axis text color
                      ),
                      lineStyle: charts.LineStyleSpec(
                        color: charts.ColorUtil.fromDartColor(Colors.cyan), // X-axis line color
                      ),
                    ),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        color: charts.ColorUtil.fromDartColor(Colors.white), // Y-axis text color
                      ),
                      lineStyle: charts.LineStyleSpec(
                        color: charts.ColorUtil.fromDartColor(Colors.cyan), // Y-axis line color
                      ),
                    ),
                  ),
                )
                    : Center(
                  child: Text('No weight data available'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  List<charts.Series<Map<String, dynamic>, String>> _createChartData() {
    int maxWeight = 0;
    int minWeight = int.parse(_weightData.first['weight'] as String);

    // Find the maximum and minimum weights
    for (var data in _weightData) {
      int weight = int.parse(data['weight'] as String);
      if (weight > maxWeight) {
        maxWeight = weight;
      }
      if (weight < minWeight) {
        minWeight = weight;
      }
    }

    // Sort the weight data based on the week number
    _weightData.sort((a, b) {
      int weekA = int.parse(RegExp(r'\d+').firstMatch(a['week'] as String)?.group(0) ?? '');
      int weekB = int.parse(RegExp(r'\d+').firstMatch(b['week'] as String)?.group(0) ?? '');
      return weekA.compareTo(weekB);
    });

    return [
      charts.Series<Map<String, dynamic>, String>(
        id: 'Weight',
        data: _weightData,
        domainFn: (datum, _) => datum['week'] as String,
        measureFn: (datum, _) => int.parse(datum['weight'] as String), // Parse weight as int
        colorFn: (datum, _) {
          int weight = int.parse(datum['weight'] as String);
          // Check if it's the maximum weight
          if (weight == maxWeight) {
            return charts.ColorUtil.fromDartColor(Colors.red); // Highlight in red
          } else if (weight == minWeight) {
            return charts.ColorUtil.fromDartColor(Colors.blue); // Highlight in blue
          } else {
            return charts.ColorUtil.fromDartColor(Colors.yellow); // Other bars in yellow
          }
        },
        labelAccessorFn: (datum, _) => '${datum['weight']} kg', // Optional: Add labels to each bar
      )
    ];
  }
}
