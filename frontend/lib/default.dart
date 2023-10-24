import 'package:flutter/material.dart';
import 'package:quiz_app/login.dart';
import 'register.dart';

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 2;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration (
          color: Color(0xff3c2aa8),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity, 
              height: screenHeight,
              decoration: const BoxDecoration (
                color: Color(0xff784192),
              ),
              child: Column(
                children: [
                  Container(
                    // ourlogorsC (4:23)
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 90), // adjust later when image included
                    padding: const EdgeInsets.fromLTRB(25, 52, 0, 0),
                    child: const Align(
                      alignment: FractionalOffset.topLeft,
                    child: Text('Logo', textAlign: TextAlign.left, style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Inter',
                      fontSize: 40,
                      letterSpacing: 0 ,
                      fontWeight: FontWeight.normal,
                      height: 1
                    ),
                    ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints (
                      maxWidth: 100,
                    ),
                    child: const Text('image placed here',textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Inter',
                        fontSize: 24,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1
                      )
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
                    constraints: const BoxConstraints (
                      maxWidth: 300,
                    ),
                    child: const Text('Our Really Cool Slogan', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Inter',
                        fontSize: 30,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        height: 1
                      )
                    ),
                  ),
              const SizedBox(height: 60.0),
            ElevatedButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 158, 48, 189),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle:
                        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                child: const Text('Sign up for free'),
              ),
            const SizedBox(height: 15.0),
             TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Login',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 255, 255, 1),)),
              ),
              const Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 18),
                        child: Text('© 2023 Copyright: QuizWiz', style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1
                      ),
                      ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
