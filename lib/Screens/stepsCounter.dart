import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

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
  bool _isListening = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  List<double> _accelerometerValues = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    super.dispose();
    _stopListening();
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
  }

  void _stopListening() {
    _accelerometerSubscription?.cancel();

    setState(() {
      _isListening = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Count'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Step Count: $_stepCount',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? 'Stop' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}
