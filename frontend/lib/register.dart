// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'home.dart';

// Define the API endpoint URL
const String apiUrl =
    'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/users/register';

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

      String baseUrl =
          "https://cop4331-27-c6dfafc737d8.herokuapp.com/doverify";
      Map<String, String> queryParams = {
        "login": login,
        "password": password,
      };

      List<String> encodedParams = [];

      // Encode each query parameter
      queryParams.forEach((key, value) {
        encodedParams.add("$key=${Uri.encodeQueryComponent(value)}");
      });

      // Construct the URI with encoded query parameters
      String uriWithParams = "$baseUrl?${encodedParams.join("&")}";

      print("Final URI with encoded query parameters: $uriWithParams");
      final verifyLink = uriWithParams;

      sendEmail(verifyLink, email);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Registration Successful. Email verification sent to $email"),
      ));

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

void sendEmail(String verifyLink, String userEmail) async {
  // Replace these values with your Mailjet API key and secret key
  String apiKey = '5ada97d0e87cdefddf373bc99b622fe8';
  String apiSecret = 'da1c2ddf1f7c3ed073aa2080de8bd237';

  // Create an email payload
    Map<String, dynamic> emailPayload = {
      'Messages': [
        {
          'From': {'Email': "quizwiz27@gmail.com", 'Name': 'QuizWiz'},
          'To': [
            {'Email': userEmail}
          ],
          'TemplateLanguage': true,
          'Subject': 'Email Verification',
          'TextPart': 'Click the link for password reset: $verifyLink',
        }
      ]
    };

  // Convert payload to JSON
  String jsonPayload = jsonEncode(emailPayload);

  // Send the email using Mailjet API
  String apiUrl = 'https://api.mailjet.com/v3.1/send';
  http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret')),
    },
    body: jsonPayload,
  );

  // Print the response
  print('Mailjet API Response: ${response.statusCode}');
  print('Response Body: ${response.body}');
}

bool validatePassword(BuildContext context, String password) {
    // Replace with your password complexity check function
    bool isComplex = isPasswordComplex(password);

    if (isComplex) {
      print('Password is complex and meets requirements.');
      return true;
      // Proceed with account creation or password update
    } else {
      print('Password does not meet complexity requirements.');
      // Display an alert to the user
      showPasswordAlert(context);
      return false;
    }
  }

  bool isPasswordComplex(String password) {
    // Your password complexity check logic
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  }

  void showPasswordAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Requirements'),
          content: Text('Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one numeric digit, and one special character.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                  if(validatePassword(context, passwordInput.text) == true) {
                    RegisterUser(context, usernameInput.text, passwordInput.text,
                        firstNameInput.text, lastNameInput.text, emailInput.text);
                  }
                  else {
                    print("does not neet password requirements");
                  }
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
