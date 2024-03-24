import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'common_navbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedImage;
  final CollectionReference _profilesCollection =
  FirebaseFirestore.instance.collection('profiles');
  late Stream<User?> _userStream;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _userStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
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
                image: AssetImage('assets/profileBG.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: StreamBuilder<User?>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasData) {
                    User? user = snapshot.data;
                    _loadProfileImage(user!.uid); // Load profile image
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _selectedImage != null
                              ? CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.15,
                            backgroundImage: AssetImage(_selectedImage!),
                          )
                              : CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.1,
                            child: Icon(Icons.person),
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'My User ID',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white, // Changing the label color to white
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${user.uid}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.tealAccent,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white, // Changing the label color to white
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${user.email}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.tealAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 60),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(
                                colors: [Colors.cyan, Colors.teal],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(1, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _showImageOptions(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'CHANGE AVATAR',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text(
                      'Not logged in',
                      style: TextStyle(fontSize: 18),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to load the user's profile image URL from Firestore
  void _loadProfileImage(String userId) async {
    try {
      DocumentSnapshot doc =
      await _profilesCollection.doc(userId).get();
      if (doc.exists && _isMounted) {
        setState(() {
          _selectedImage = doc['profileImage'];
        });
      }
    } catch (error) {
      if (_isMounted) {
        print('Failed to load profile image: $error');
      }
    }
  }

  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Avatar'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _imageOptionTile('assets/avatar/avatar1.jpg'),
                _imageOptionTile('assets/avatar/avatar2.jpg'),
                _imageOptionTile('assets/avatar/avatar3.jpg'),
                _imageOptionTile('assets/avatar/avatar4.jpg'),
                _imageOptionTile('assets/avatar/avatar5.png'),
                _imageOptionTile('assets/avatar/avatar6.png'),
                _imageOptionTile('assets/avatar/avatar7.jpg'),
                _imageOptionTile('assets/avatar/avatar8.png'),
                _imageOptionTile('assets/avatar/avatar9.jpg'),
                _imageOptionTile('assets/avatar/avatar10.jpg'),
                _imageOptionTile('assets/avatar/avatar11.jpg'),
                _imageOptionTile('assets/avatar/avatar12.jpg'),
                _imageOptionTile('assets/avatar/avatar13.jpg'),
                _imageOptionTile('assets/avatar/avatar14.jpg'),
                _imageOptionTile('assets/avatar/avatar15.jpg'),
                _imageOptionTile('assets/avatar/avatar16.jpg'),
                _imageOptionTile('assets/avatar/avatar17.jpg'),
                _imageOptionTile('assets/avatar/avatar18.jpg'),
                _imageOptionTile('assets/avatar/avatar19.jpg'),
                _imageOptionTile('assets/avatar/avatar20.jpg'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageOptionTile(String imagePath) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(imagePath.split('/').last),
      onTap: () async {
        // Check if the widget is mounted before calling setState
        if (!mounted) return;

        setState(() {
          _selectedImage = imagePath;
        });



        // Store the selected image URL in Firestore
        if (_selectedImage != null) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            try {
              await _profilesCollection.doc(user.uid).set({
                'profileImage': _selectedImage!,
              }, SetOptions(merge: true));
            } catch (error) {
              print('Failed to update profile image: $error');
            }
          }
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
