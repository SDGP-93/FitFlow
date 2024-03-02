import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors/sensors.dart';

void main() {
  runApp(const MaterialApp(
    home: StepCountPage(),
  ));
}

class StepCountPage extends StatefulWidget {
  const StepCountPage({super.key});

  @override
  _StepCountPageState createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  int _stepCount = 0;
  double _caloriesBurned = 0;
  bool _isListening = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<Position>? _positionSubscription;
  List<double> _accelerometerValues = [0, 0, 0];
  double _previousMagnitude = 0;
  final double _threshold = 11.0; // can Adjust 
  bool _isStepDetected = false;

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

    _positionSubscription = Geolocator.getPositionStream().listen((Position position) {
      //  GPS data  
    });

    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _accelerometerSubscription?.cancel();
    _positionSubscription?.cancel();

    setState(() {
      _isListening = false;
    });
  }

  void _checkForStep() {
    final double currentAccelerationMagnitude = _accelerometerValues.fold(0, (previous, current) => previous + current.abs());
    
    if (_isStepDetected && currentAccelerationMagnitude < _threshold * 0.8) {
      _isStepDetected = false;
    }

    if (!_isStepDetected && currentAccelerationMagnitude > _threshold * 1.2 && _previousMagnitude < _threshold * 0.8) {
      _isStepDetected = true;
      setState(() {
        _stepCount++;
        _caloriesBurned = _calculateCalories(_stepCount);
      });
    }

    _previousMagnitude = currentAccelerationMagnitude;
  }

  double _calculateCalories(int steps) {
    return steps * 0.04;//  assume 0.04 calories burned per step
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Count'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Step Count: $_stepCount',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Calories Burned: ${_caloriesBurned.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
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
