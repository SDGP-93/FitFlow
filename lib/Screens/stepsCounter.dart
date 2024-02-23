import 'dart:math'; //to use mathematical functions
import 'package:flutter/material.dart'; //which contains widgets and classes for building material design UIs.
import 'package:pedometer/pedometer.dart'; //to access pedometer functionality

//the entry point of the step counter page
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //the root of the page
  const MyApp({Key? key}) : super(key: key); // Constructor for MyApp widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Setting the home property of MaterialApp to a Scaffold widget
        appBar: AppBar(
          // Configuring the app bar with a title
          title: const Text('My Steps Counter'), // Setting the title text
          centerTitle: true, // Centering the title
        ),
        body: const Center(
          child:
              StepCounterCircle(), // Displaying the StepCounterCircle widget in the center of the screen.
        ),
      ),
    );
  }
}

class StepCounterCircle extends StatefulWidget {
  // Defining a StatefulWidget called StepCounterCircle
  const StepCounterCircle({Key? key})
      : super(key: key); // Constructor for StepCounterCircle widget

  @override
  State<StepCounterCircle> createState() =>
      _StepCounterCircleState(); //return a new instance of _StepCounterCircleState.
}

class _StepCounterCircleState extends State<StepCounterCircle> {
  // The State class for StepCounterCircle widget
  int _steps = 0; //store the current number of steps
  final int _goalSteps = 10000; //store the goal number of steps
  late Stream<StepCount> _stepCountStream; //listen for step count updates

  @override
  void initState() {
    super.initState(); // Initializing the state
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    //handle step count updates
    setState(() {
      _steps = event.steps; // Updating the number of steps
    });
  }

  void initPlatformState() async {
    try {
      _stepCountStream = Pedometer.stepCountStream.handleError(
          onError); // Attempt to get the step count stream from the Pedometer package
      _stepCountStream.listen(
          onStepCount); // Listen to the step count stream and call onStepCount method whenever new step count data is available
    } catch (error) {
      print(
          'Error initializing pedometer: $error'); // If there's an error initializing the pedometer, print the error message
    }
  }

  void onError(error) {
    // Handle errors
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StepCirclePainter(
          steps: _steps,
          goalSteps:
              _goalSteps), // CustomPaint widget allows custom painting using a provided painter
      child: Center(
        // Center widget centers its child horizontally and vertically within itself
        child: Text(
          '$_steps / $_goalSteps Steps', // Displaying the current step count and goal steps as text
          style: Theme.of(context)
              .textTheme
              .titleLarge, //style defined in the app's theme
        ),
      ),
    );
  }
}

class StepCirclePainter extends CustomPainter {
  //ainting a circular progress indicator
  final int steps; //store the current step
  final int goalSteps; //store the goal steps

  StepCirclePainter(
      {required this.steps,
      required this.goalSteps}); // Constructor to initialize the properties

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
