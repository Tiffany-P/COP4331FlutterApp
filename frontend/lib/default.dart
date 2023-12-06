import 'package:flutter/material.dart';
import 'package:quiz_app/login.dart';
import 'register.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', width: 160, height: 190),
        backgroundColor: const Color.fromARGB(255, 66, 65, 146),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff3c2aa8),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Color(0xff784192),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Image.asset(
                      'assets/images/wizard_desk.png',
                      width: 390, // Increase the width to make the image larger
                      height:
                          400, // Increase the height to make the image larger
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: const Text('Embrace the Magic of Learning',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Inter',
                      fontSize: 25,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      height: 1)),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 158, 48, 189),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  )),
            ),
            const Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Text(
                    '© 2023 Copyright: QuizWiz',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1),
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
