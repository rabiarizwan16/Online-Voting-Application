
import 'dart:async';

import 'package:flutter/material.dart';

class GridViewScreen extends StatefulWidget {
  const GridViewScreen({super.key});


  @override
  State<GridViewScreen> createState() => _GridViewScreenState();

}

class StudentModel{
  final String img;

  StudentModel({ required this.img});

}


class _GridViewScreenState extends State<GridViewScreen> {
  List<StudentModel> studentModel = [
    StudentModel(
        img: "assets/images/vote1.jpeg"),
    StudentModel(
        img: "assets/images/vote2.jpg",
        ),
    StudentModel(
        img: "assets/images/vote3.jpg",
       ),
    StudentModel(
        img: "assets/images/vote4.jpg",
        ),
  ];



  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Set up a periodic timer to scroll the SingleChildScrollView automatically
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        final delta = MediaQuery.of(context).size.width; // Scroll by

        if (currentScroll < maxScroll) {
          _scrollController.animateTo(
            currentScroll + delta,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _scrollController.dispose(); // Dispose of the scroll controller
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(

          children: studentModel.map((model) {
            return
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:0.0),
                      child: Image.asset(
                        model.img,
                        height: 200,
                        width: MediaQuery.of(context).size.width, // Adjust width as needed
                        fit: BoxFit.fill,
                      ),
                    ),


                  ],
              );

          }).toList(),
        ),
    );


  }
}














