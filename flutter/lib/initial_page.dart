import 'package:flutter/material.dart';
import 'package:surevote/admin_login_page.dart';
import 'package:surevote/grid_view.dart';
import 'package:surevote/result_page.dart';
import 'package:surevote/show_candidates.dart';
import 'package:surevote/voter_panel.dart';
import 'drawer.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int _currentIndex = 0; // Tracks the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF00165a),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Voter Registration",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,
                color: Color(0xFFFAF9F6),
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0), // Position of the shadow
                    blurRadius: 3.0, // Softness of the shadow
                    color: Colors.black.withOpacity(0.5), // Shadow color
                  ),
                ]),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        elevation: 0,
        backgroundColor: const Color(0xFF00165a),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/images/logo.png', // Path to your logo image
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),

        drawer: AppDrawer(),
      body:
    Stack(
        children: [
          // Main container with white background
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Color(0xFFE6F7FF),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.5),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(38),
                    child: Container(
                      width: 370,
                      height: 200,
                      color: Colors.white,
                      child: const Center(child: GridViewScreen()),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Admin Panel Button
                  Container(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLoginScreen()),
                          );
                        },
                        child: const Text(
                          'Admin Panel',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00165a),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Voter Panel Button
                  Container(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoterPanel()),
                          );
                        },
                        child: const Text(
                          'Voter Panel',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00165a),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CandidatesPage()),
                          );
                        },
                        child: const Text(
                          'View Candidates',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00165a),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Voter Panel Button
                  Container(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VotingResultsPage()),
                          );
                        },
                        child: const Text(
                          'Result',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00165a),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          // Positioned asset image at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.7, // Light blue tint effect
              child: Image.asset(
                'assets/images/hand_new.png', // Replace with your asset path
                fit: BoxFit.cover,
                height: 230, // Adjust the height as needed
              ),
            ),
          ),
        ],
      ),


    );
  }
}
