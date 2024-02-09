import 'package:flutter/material.dart';
import 'logIn.dart';
import 'signUp.dart';

class StartUp extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  String logInBtnText = 'Log In';
  String signUpBtnText = 'Sign Up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("    FitFlow"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/FitFlow_logo.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the LoginPage when Log In button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => logIn()),
              );
            },
            child: Text(logInBtnText),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the LoginPage when Log In button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => signUp()),
              );
            },
            child: Text(signUpBtnText),
          ),
        ],
      ),
    );
  }
}

