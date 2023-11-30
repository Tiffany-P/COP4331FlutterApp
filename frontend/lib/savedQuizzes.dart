import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'flashcardsPage.dart';

String userId = '';

class savedQuizzesPage extends StatefulWidget {
  String id;

  savedQuizzesPage({super.key, required this.id}) {
    userId = id;
  }

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<savedQuizzesPage> {
  List<Map<String, dynamic>> quizList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("userid" + userId);
    fetchQuizID();
  }

  Future<void> fetchQuizNames(String quizId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/quizzes/get'),
      body: json.encode({'id': quizId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Quiz Data:");
      print(data);

      if (data['Name'] != null) {
        setState(() {
          quizList.add({
            'QuizId': quizId,
            'QuizName': data['Name'], // Adjust to match your actual structure
          });
        });
      }
    }
  }

  Future<void> fetchQuizID() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/saved/get'),
      body: json.encode({'id': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("Quiz Data:");
      print(data);

      setState(() {
        quizList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });

      // Only fetch quiz names if there are saved quizzes
      // commenting this makes it show 2 times
      if (quizList.isNotEmpty) {
        for (final quiz in quizList) {
          fetchQuizNames(quiz['QuizId']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 140,
        ),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
      ),
      backgroundColor: Color.fromARGB(255, 56, 17, 91),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Left-align the title
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Saved Quizzes', // Replace with your desired title
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: quizList.length,
                    itemBuilder: (context, index) {
                      final quiz = quizList[index];
                      if (quiz['QuizId'] != null && quiz['QuizName'] != null) {
                        return FlashCardWidget(
                          quizId: quiz['QuizId'] as String,
                          quizName: quiz['QuizName'] as String,
                        );
                      } else {
                        return SizedBox(); // Return an empty SizedBox if either QuizId or QuizName is null
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class FlashCardWidget extends StatelessWidget {
  final String quizId;
  final String quizName;
  final currentIndex = 0;

  FlashCardWidget({required this.quizId, required this.quizName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FlashcardPage(
                  quizId: quizId, name: quizName, userId: userId)),
        );
        // Handle the tap, you can navigate to another screen or perform any action with the quizId
        print('Tapped on Quiz ID: $quizId');
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Card(
          color: Color.fromARGB(255, 86, 17, 183),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12.0), // Set corner radius to 12 for rounded corners
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '$quizName',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
