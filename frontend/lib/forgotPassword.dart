import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quiz_app/resetPassword.dart';

final String apiUrl = 'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/users/login';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController userController = TextEditingController();
  String userEmail = '';

  Future<void> fetchEmail(String userId) async {
    print('Quiz ID in fetch questions: $userId');
    const String apiUrl = 'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/users/getemail';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'login': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print("Get Email Data:");
        print(data);

        setState(() {
          // Update the state as needed
          userEmail = data['result']['Email'];
        });
        print("email: $userEmail");

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
  void _sendPassLink(String userId) {
    // Implement your logic to send a password reset link using the provided email
    String login = userController.text;
    fetchEmail(userId);
     print('Sending password reset link to $userEmail');
    // Add your API call or other logic here
    String baseUrl =
          "https://cop4331-27-c6dfafc737d8.herokuapp.com/doreset";
      Map<String, String> queryParams = {
        "login": login,
      };

      List<String> encodedParams = [];

      // Encode each query parameter
      queryParams.forEach((key, value) {
        encodedParams.add("$key=${Uri.encodeQueryComponent(value)}");
      });

      // Construct the URI with encoded query parameters
      String uriWithParams = "$baseUrl?${encodedParams.join("&")}";

      print("Final URI with encoded query parameters: $uriWithParams");
      final userLink = uriWithParams;
      sendEmail(userEmail, userLink);
  }

  void sendEmail(String userEmail, String userLink) async {
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
          'Subject': 'Password Recovery',
          'TextPart': 'Recover password with link: $userLink',
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
                'Enter the username associated with the account.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: userController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183), width: 4.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 86, 17, 183),
                        width: 4.0), // Set your desired color
                  ),
                  hintText: 'Enter your username',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 86, 17, 183)),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                    _sendPassLink(userController.text);
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPasswordPage(login2: userController.text)),
                  );
                },
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

/*void sendEmail() async {
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
}*/
