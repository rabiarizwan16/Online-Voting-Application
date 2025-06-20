import 'dart:async';
import 'package:flutter/material.dart';
import 'package:surevote/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navigate to the next page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>WelcomePage()), // Replace with your next page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/istockphoto-458548965-612x612-1.jpg'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light blue overlay
          Container(
            color: Colors.lightBlue.withOpacity(0.74), // Light blue shade with transparency
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with finger
              Padding(
                padding: const EdgeInsets.only(top:100.0),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF002c56), // Dark blue circle
                      shape: BoxShape.circle,
                    ),
                  child: Center(
                        child: Image.asset(
                          'assets/images/vote_box.png', // Replace with your logo
                          height: 160,
                          width: 160,
                        ),
                      ),
                    ),
                  ),
              ),

              SizedBox(height: 20),
              // "Voter" text
              Text(
                'SureVote',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFAF9F6),
                ),
              ),
              SizedBox(height: 5),
              // "Voter Helpline" text

              SizedBox(height: 10),
              // Decorative line
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              SizedBox(height: 15),
              // Bottom text and logo
              Spacer(),
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your Election Commission logo
                    height: 50,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'भारत निर्वाचन आयोग\nElection Commission Of India',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}


