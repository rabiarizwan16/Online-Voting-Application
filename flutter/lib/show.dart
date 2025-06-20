import 'package:flutter/material.dart';

class TempMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      home: Scaffold(
        backgroundColor: Colors.indigo.shade800,
        appBar: AppBar(
          title: Text(
            'Test App',
          ),
          elevation: 0,
          backgroundColor: Colors.indigo.shade800,
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            ),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}