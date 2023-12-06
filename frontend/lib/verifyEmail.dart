import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

String verifyLink = '';
String email = '';

class VerifyEmailPage extends StatefulWidget {
    String verifyLink1;
    String email1;
    VerifyEmailPage(this.verifyLink1, this.email1, {super.key}) {
      verifyLink =verifyLink1;
      email = email1;
    }

   _VerifyEmailPageState createState() => _VerifyEmailPageState();
    
  
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    // Your initialization code here
    sendEmail(verifyLink, email);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
      ),
      backgroundColor: Color.fromRGBO(52, 14, 87, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Registration successful. Email verification sent to:',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                email, // Replace with the actual email
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                 
                  sendEmail(verifyLink, email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Verification email resent!'),
                    ),
                  );
                },
                 style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 158, 48, 189),
                    padding:
                        EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                child: Text('Resend Email'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                 
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 158, 48, 189),
                    padding:
                        EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
