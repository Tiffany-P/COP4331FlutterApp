import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuizWizz'),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 41, 5, 73),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 30.0),
          Text(
            '   Popular',
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 24, // Set text font size
            ),
          ),
          const SizedBox(height: 30.0),
          Text(
            '   Suggested',
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 24, // Set text font size
            ),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
