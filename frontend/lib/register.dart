// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'home.dart';

// Define the API endpoint URL
final String apiUrl = 'http://10.0.2.2:5000/api/users/register';

class User {
  final String login;
  final String password;
  final String firstName;
  final String lastName;
  final String email;

  User(this.login, this.password, this.firstName, this.lastName, this.email);

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };
}

Future<void> RegisterUser(BuildContext context, String login, String password,
    String firstName, String lastName, String email) async {
  final user = User(login, password, firstName, lastName, email);
  final userJson = jsonEncode(user);

  print("User: $login, Pass: $password");

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: userJson,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = json.decode(response.body);
      // final String id = res['id'];
      // print(id);
      // if (id != null) {
      // } else {
      // Login successful, handle the response, e.g., parse authentication tokens.
      final responseData = json.decode(response.body);
      final authToken = responseData['authToken'];
      final refreshToken = responseData['refreshToken'];

      print("User: $login, Pass: $password");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      // }

      // You can save these tokens for future authenticated requests.
    } else {
      // Handle authentication failure, e.g., show an error message.
      // You can use a SnackBar, showDialog, or another UI element to display the error.
      // For simplicity, we'll print the error to the console here.
      print('Authentication failed: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or server connection issues.
    print('Error: $e');
  }
}

class RegisterPage extends StatelessWidget {
  TextEditingController usernameInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController firstNameInput = TextEditingController();
  TextEditingController lastNameInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameInput,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                ),
              ),
              TextField(
                controller: passwordInput,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                ),
              ),
              TextField(
                controller: firstNameInput,
                decoration: InputDecoration(
                  labelText: 'First name',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                ),
              ),
              TextField(
                controller: lastNameInput,
                decoration: InputDecoration(
                  labelText: 'Last name',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                ),
              ),
              TextField(
                controller: emailInput,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  RegisterUser(context, usernameInput.text, passwordInput.text,
                      firstNameInput.text, lastNameInput.text, emailInput.text);
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 158, 48, 189),
                    padding:
                        EdgeInsets.symmetric(horizontal: 114, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                child: Text('Sign up'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Already have an account? Log in',
                    style: TextStyle(color: Color.fromARGB(255, 86, 17, 183))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
