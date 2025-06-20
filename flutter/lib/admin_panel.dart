import 'package:flutter/material.dart';
import 'package:surevote/manage_position.dart';
import 'package:surevote/result_page.dart';

import 'manage_admin.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00165a),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Admin Panel", style: TextStyle(color: Colors.white)),
      ),

      body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/admin.jpg'), // Replace with your image
    fit: BoxFit.cover, // Ensures the image covers the screen
    ),
    ),
      child:Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0), // Add padding to the body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
          children: [
            _buildAdminButton('   Manage Admin   ', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAdminPage(),
                ),
              );
              // Add your logic for managing admin here
              print('Manage Admin button pressed');
            }),
            SizedBox(height: 10),
            _buildAdminButton('  Manage Position  ', () {
              // Add your logic for managing position here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagePositionsPage(),
                ),
              );
              print('Manage Position button pressed');
            }),
            // SizedBox(height: 10),
            // _buildAdminButton(' Manage Candidate ', () {
            //   // Add your logic for managing candidates here
            //   print('Manage Candidate button pressed');
            // }),
            SizedBox(height: 10),
            _buildAdminButton('            Result            ', () {
              // Add your logic for viewing results here
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => VotingResultsPage(),
              ),
              );
              print('Result button pressed');
            }),
          ],
        ),
      ),
      ),
    );
  }

  // Helper method to build buttons
  Widget _buildAdminButton(String title, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00165a), // Button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}