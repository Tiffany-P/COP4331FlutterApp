import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

final String apiUrl = 'http://cop4331-27-c6dfafc737d8.herokuapp.com/api/users/login';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  void _sendPassLink() {
    // Implement your logic to send a password reset link using the provided email
    String email = emailController.text;
    print('Sending password reset link to $email');
    // Add your API call or other logic here
    sendEmail(email);
  }

  void sendEmail(String userEmail) async {
    // Replace these values with your Mailjet API key and secret key
    String apiKey = '5ada97d0e87cdefddf373bc99b622fe8';
    String apiSecret = 'da1c2ddf1f7c3ed073aa2080de8bd237';
    String password = 'pass';

    // Create an email payload
    Map<String, dynamic> emailPayload = {
      'Messages': [
        {
          'From': {'Email': "quizwiz27@gmail.com", 'Name': 'QuizWiz'},
          'To': [
            {'Email': userEmail}
          ],
          'TemplateLanguage': true,
          'Subject': 'Password Recovery',
          'TextPart': 'Test Test Password: $password',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183),
                        width: 4.0), // Set your desired color
                  ),
                  hintText: 'Enter your email',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _sendPassLink,
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 158, 48, 189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                child: const Text('Send Password Recovery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void sendEmail() async {
  // Replace these values with your Mailjet API key and secret key
  String apiKey = '5ada97d0e87cdefddf373bc99b622fe8';
  String apiSecret = 'da1c2ddf1f7c3ed073aa2080de8bd237';

  // Create an email payload
  Map<String, dynamic> emailPayload = {
    'Messages': [
      {
        'From': {'Email': "quizwiz27@gmail.com", 'Name': 'Your Name'},
        'To': [
          {'Email': "gescobar2002@gmail.com", 'Name': 'Recipient Name'}
        ],
        'Subject': 'Test Email from Flutter',
        'TextPart': 'This is a test email sent from Flutter using Mailjet.',
        'HTMLPart':
            '<p>This is a test email sent from <b>Flutter</b> using Mailjet.</p>',
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
