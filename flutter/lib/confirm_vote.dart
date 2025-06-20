import 'package:flutter/material.dart';
import 'dart:async';

import 'initial_page.dart';

class VoteConfirmationScreen extends StatefulWidget {
  @override
  _VoteConfirmationScreenState createState() => _VoteConfirmationScreenState();
}

class _VoteConfirmationScreenState extends State<VoteConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Redirect to home screen after 3 seconds
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InitialPage()),
      );
      // Replace with your home screen route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circle with tick icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.2),
              ),
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Vote Submitted Successfully!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
