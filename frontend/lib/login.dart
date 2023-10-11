import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart';
import 'home.dart';

// Define the API endpoint URL
final String apiUrl = 'http://10.0.2.2:5000/api/login';

class User {
  final String login;
  final String password;

  User(this.login, this.password);

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
      };
}

Future<void> loginUser(
    BuildContext context, String login, String password) async {
  final user = User(login, password);
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
      // Login successful, handle the response, e.g., parse authentication tokens.
      final responseData = json.decode(response.body);
      final authToken = responseData['authToken'];
      final refreshToken = responseData['refreshToken'];

      print("User: $login, Pass: $password");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

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

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Get username and password from text fields
                String username = 'TiffP'; // Replace with actual username input
                String password =
                    'COP4331'; // Replace with actual password input

                loginUser(context, username, password);
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
