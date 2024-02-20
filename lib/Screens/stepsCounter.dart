import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Steps Counter 10'),
          centerTitle: true,
        ),
        body: const Center(
          child: StepCounterCircle(),
        ),
      ),
    );
  }
}

class StepCounterCircle extends StatefulWidget {
  const StepCounterCircle({Key? key}) : super(key: key);

  @override
  State<StepCounterCircle> createState() => _StepCounterCircleState();
}

class _StepCounterCircleState extends State<StepCounterCircle> {
  int _steps = 0;
  final int _goalSteps = 10000;
  late Stream<StepCount> _stepCountStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
    });
  }

  void initPlatformState() async {
    try {
      _stepCountStream = Pedometer.stepCountStream.handleError(onError);
      _stepCountStream.listen(onStepCount);
    } catch (error) {
      print('Error initializing pedometer: $error');
    }
  }

  void onError(error) {
    // Handle errors appropriately
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StepCirclePainter(steps: _steps, goalSteps: _goalSteps),
      child: Center(
        child: Text(
          '$_steps / $_goalSteps Steps',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class StepCirclePainter extends CustomPainter {
  final int steps;
  final int goalSteps;

  StepCirclePainter({required this.steps, required this.goalSteps});

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate progress as a percentage
    double progress = steps / goalSteps;

    // Define colors for background and progress
    Color progressColor = Colors.blue;

    // Calculate center and radius of the circle
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw background circle
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 5; // Adjust stroke width as needed
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 5; // Match background stroke width
    // Start from 12 o'clock position
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start angle
      2 * pi * progress, // Sweep angle based on progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Trigger repaints when steps or goalSteps change
  }
}
