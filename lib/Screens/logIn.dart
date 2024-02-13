import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_success.dart';

class logIn extends StatefulWidget {
  const logIn({Key? key}) : super(key: key);

  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = ''; // Added variable for error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove app top bar
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loginBG.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                ),
                style: TextStyle(color: Colors.yellow), // Set text field text color to yellow
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _errorMessage, // Display error message
                  labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                ),
                style: TextStyle(color: Colors.yellow), // Set text field text color to yellow
              ),
              const SizedBox(height: 32),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.blue], // Gradient colors
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      // Login successful, navigate to the success screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login_success()),
                      );
                    } on FirebaseAuthException catch (e) {
                      // Handle specific errors
                      if (e.code == 'wrong-password') {
                        setState(() {
                          _errorMessage = 'Invalid password';
                        });
                      } else {
                        setState(() {
                          _errorMessage = 'Login failed: $e';
                        });
                      }
                    } catch (e) {
                      // Handle other errors
                      setState(() {
                        _errorMessage = 'Login failed: $e';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10), // Increase padding for better visibility
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0, // Remove button elevation
                    backgroundColor: Colors.transparent, // Remove button background color
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white), // Set button text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
