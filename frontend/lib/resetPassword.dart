import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

String login = '';
class ResetPasswordPage extends StatefulWidget {
  String login2;

  ResetPasswordPage({super.key, required this.login2}) {
    login = login2;
  }
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}


class _ResetPasswordPageState extends State<ResetPasswordPage> {
  
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> doReset(String userId, String newPassword) async {
    print('Quiz ID in fetch questions: $userId');
    const String apiUrl = 'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/users/recovery';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'login': userId, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print("Get Recovery Data: $data");
       

      } else {
        // Handle the case when no questions are found or an error occurs.
        // You can show an error message or take appropriate action here.
        print("error:");
      }
    } catch (e) {
      // Handle network or server connection issues.
      // You can show an error message or take appropriate action here.
    }
  }
  void _resetPassword() {
    // Implement your password reset logic here
    
    String newPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword == confirmPassword) {
      // Passwords match, proceed with the reset logic
      // For example, you can call an API to update the password
      print("calling reset");
      doReset(login, newPassword);
      
      print("Password reset successful");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password Updated"),
        ));
    } else {
      // Passwords do not match, show an error message
      print("Passwords do not match");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 158, 48, 189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              child: Text('Reset Password'),
            ),
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
                    color: Color.fromRGBO(0, 0, 0, 1),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}