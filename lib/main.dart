import 'package:auth3/Screens/home.dart';
import 'package:auth3/Screens/input.dart';
import 'package:auth3/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/startUp.dart';


Future <void> main()async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFlow App',
      home: startUp(), // Use the StartUp widget as the home
    );
  }
}