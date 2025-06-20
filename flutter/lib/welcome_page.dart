import 'package:flutter/material.dart';
import 'package:surevote/first_login.dart';
import 'package:surevote/initial_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F7FF), // Light blue background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top bar with icons
          
              SizedBox(height: 20),
          
              // Illustration
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo1.png', // Replace with your desired image
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 30),
          
              // Title text
              Text(
                "EVERY VOTE MATTERS",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00165A), // Dark blue color
                ),
              ),
              SizedBox(height: 10),
          
              // Subtitle text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Somewhere inside of us \n is the power to change the \n  world.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 80,),
          
              // "Continue" button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewLoginPage()),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00165A), // Button color
                    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
