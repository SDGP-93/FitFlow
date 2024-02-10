import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'input.dart';

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
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorMessage, // Display error message
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  // Login successful, navigate to the success screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => input()),
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
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

