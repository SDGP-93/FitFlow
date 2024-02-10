import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/welcomeBG.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    children: [
                      buildButton(context, '', 'assets/db.png'),
                      buildButton(context, '', 'assets/cal3.png'),
                      buildButton(context, '', 'assets/pro2.png'),
                      buildButton(context, '', 'assets/logo.png'),
                      buildButton(context, '', 'assets/set.png'),
                      buildButton(context, '', 'assets/feed.png'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(
      BuildContext context, String buttonText, String backgroundImage) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1.0,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (backgroundImage == 'assets/pro2.png') {
            // Navigate to Progress Tracking Page
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WeightSetPage()),
            );*/
          } else {
            // Handle other button clicks
            // TODO: Implement button functionality
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0),
          shadowColor: Color.fromARGB(255, 0, 0, 0),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}