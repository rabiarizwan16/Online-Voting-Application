import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoterPanel(),
    );
  }
}

class VoterPanel extends StatefulWidget {
  @override
  _VoterPanelState createState() => _VoterPanelState();
}

class _VoterPanelState extends State<VoterPanel> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    LoginPage(),
    RegistrationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),


    );
  }
}
