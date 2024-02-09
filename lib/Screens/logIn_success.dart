import 'package:flutter/material.dart';

class login_success extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FitFlows"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Log In Successful",
          style: TextStyle(
            fontSize: 24.0, // Set the font size
            fontWeight: FontWeight.bold, // Optionally set the font weight
          ),
        ),
      ),
    );
  }
}
