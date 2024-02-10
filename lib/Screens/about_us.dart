import 'package:flutter/material.dart';

class FitflowHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand, // Make the Stack fill the entire screen
        children: [
          // Background Image
          Image.asset(
            'assets/hfBG.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0), // Adjust as needed
                // Fitflow Logo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
                  ),
                ),
                SizedBox(height: 130),
                // Description about Fitflow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '"ᴀᴘᴘʟɪᴄᴀᴛɪᴏɴ ᴅᴇꜱɪɢɴᴇᴅ ᴛᴏ ᴍᴇᴇᴛ ᴛʜᴇ ᴠᴀʀɪᴏᴜꜱ ɴᴇᴇᴅꜱ ᴏꜰ ᴄᴜꜱᴛᴏᴍᴇʀꜱ ʟᴏᴏᴋɪɴɢ ꜰᴏʀ ᴀ ᴘᴇʀꜱᴏɴᴀʟɪᴢᴇᴅ ᴀɴᴅ ᴇꜰꜰɪᴄɪᴇɴᴛ ᴡᴏʀᴋᴏᴜᴛ ᴘʟᴀɴ ᴇxᴘᴇʀɪᴇɴᴄᴇ ᴀɴᴅ ᴄᴏᴍʙᴀᴛ ᴏʙᴇꜱɪᴛʏ ʀᴇʟᴀᴛᴇᴅ ʜᴇᴀʟᴛʜ ᴘʀᴏʙʟᴇᴍꜱ"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                // Social Media Icons
                GridView.count(
                  crossAxisCount: 2, // 2 items per row
                  shrinkWrap: true,
                  padding: EdgeInsets.all(100),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  children: [
                    buildSocialMediaIcon('assets/insta.png'),
                    buildSocialMediaIcon('assets/fb.png'),
                    buildSocialMediaIcon('assets/tele.png'),
                    buildSocialMediaIcon('assets/x.png'),
                  ],
                ),
                SizedBox(height: 10), // Adjust spacing between the grid and bottom edge
                SizedBox(height: 10), // Additional space to prevent boxes from touching the bottom edge
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSocialMediaIcon(String imagePath) {
    return GestureDetector(
      onTap: () {
        // Handle social media icon tap
        // TODO: Add functionality to open respective social media platform
      },
      child: Container(
        height: 10, // Adjust height as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent, // Make the background color transparent
        ),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FitflowHistoryPage(),
  ));
}
