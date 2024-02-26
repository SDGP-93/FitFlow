import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'common_navbar.dart';

class UsernamePage extends StatefulWidget {
  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  late TextEditingController _usernameController;
  late String _currentUserName = 'username123'; // Default value
  late String _userId;
  final CollectionReference _infoCollection =
  FirebaseFirestore.instance.collection('info');

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userId = user.uid;
        DocumentSnapshot doc = await _infoCollection.doc(_userId).get();
        if (doc.exists) {
          setState(() {
            _currentUserName = doc['username'];
            _usernameController.text = _currentUserName;
          });
        }
      }
    } catch (error) {
      print('Failed to load user data: $error');
    }
  }

  Future<void> _updateName(String newName) async {
    try {
      await _infoCollection.doc(_userId).set({'username': newName});
      setState(() {
        _currentUserName = newName;
      });
    } catch (error) {
      print('Failed to update username: $error');
    }
  }

  void _editNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Username'),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(hintText: 'Enter your Username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateName(_usernameController.text);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonNavBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/usernameBg.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentUserName,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal,
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _editNameDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'EDIT USERNAME',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UsernamePage(),
  ));
}
