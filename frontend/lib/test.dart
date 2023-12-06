import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String quizId = '';
String quizName = '';

class TestPage extends StatefulWidget {
  String id;
  String name;

  TestPage({super.key, required this.id, required this.name}) {
    quizId = id;
    quizName = name;
  }
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int score = 0;
  List<String?> selectedAnswers = [];
  bool quizSubmitted = false;
  bool isLoading = true;

  Future<void> fetchQuestions(String quizId) async {
    print('Quiz ID in fetch questions2: $quizId');
    const String apiUrl =
        'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/questions/search';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'term': '', 'quizId': quizId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print("Quiz Data2:");
        print(data['result']);

        List<dynamic> ques = data['result']
            .map((item) => Question(item['Question'], item['_id']))
            .toList();
        // flashcards = data.map((item) => Flashcard(item['_id'])).toList();

        print("QUes $ques");
        print("Getting answer:");

        for (dynamic question in ques) {
          final answers = await fetchAnswer(question.questionId);

          List<String> ans = [];
          answers.map((e) => {ans.add(e['Answer'] as String)}).toList();
          question.correctAnswer = ans.elementAt(0);
          ans.shuffle();
          question.answerChoices = ans;
        }

        setState(() {
          questions = ques;
          selectedAnswers = List.filled(questions.length, null);
          isLoading = false;
        });
      } else {
        // Handle the case when no questions are found or an error occurs.
        // You can show an error message or take appropriate action here.
        print("error:");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle network or server connection issues.
      // You can show an error message or take appropriate action here.
    }
  }

  Future<List<dynamic>> fetchAnswer(String questionId) async {
    print("API answers for questiond id:$questionId");
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:5000/api/answers/get'),
    //   body: json.encode({'questionId': questionId}),
    //   headers: {'Content-Type': 'application/json'},
    // );

    final response = await http.post(
      Uri.parse(
          'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/answers/get'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'questionId': questionId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print("Question Data Answers:");
      print(data['result']);
      List<dynamic> results = data['result'];

      return results;
    }
    List<dynamic> res = [];
    res.add('No Answers');
    return res;
  }

  List<dynamic> questions = [];

  void checkAnswer(String selectedAnswer, int questionIndex) {
    String? correctAnswer = questions[questionIndex].correctAnswer;

    selectedAnswers[questionIndex] = selectedAnswer;

    setState(() {});
  }

  void submitQuiz() {
    // Calculate the final score here
    score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        score++;
      }
    }

    // Set the flag to indicate that the quiz has been submitted
    setState(() {
      quizSubmitted = true;
    });

    // Show the result dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content:
              Text('Your final score is $score out of ${questions.length}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the result dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void retakeQuiz() {
    // Reset the quiz state
    setState(() {
      score = 0;
      selectedAnswers = List.filled(questions.length, null);
      quizSubmitted = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuestions(quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Test'),
          backgroundColor: const Color.fromARGB(255, 86, 17, 183)),
      backgroundColor: const Color.fromRGBO(67, 39, 161, 1),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(top: 30.0, bottom: 10, left: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    trackVisibility: true,
                    thickness: 12.0,
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isCorrect = selectedAnswers[index] ==
                            questions[index].correctAnswer;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(48, 60, 84, 1),
                              border: Border.all(
                                  color: Color.fromRGBO(48, 60, 84, 1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Question ${index + 1}: ${questions[index].questionText}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 20.0),
                                ...questions[index].answerChoices.map(
                                      (choice) => ElevatedButton(
                                        onPressed: quizSubmitted
                                            ? () {}
                                            : () => checkAnswer(choice!, index),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Adjust the radius as needed
                                          ),
                                          primary: quizSubmitted
                                              ? (selectedAnswers[index] ==
                                                      choice
                                                  ? (isCorrect
                                                      ? Color.fromRGBO(
                                                          76, 175, 80, 1)
                                                      : Color.fromRGBO(
                                                          244, 67, 54, 1))
                                                  : Color.fromRGBO(
                                                      92, 66, 179, 1))
                                              : (selectedAnswers[index] ==
                                                      choice
                                                  ? Color.fromARGB(
                                                      255, 126, 113, 170)
                                                  : Color.fromRGBO(
                                                      92, 66, 179, 1)),
                                          onPrimary: quizSubmitted
                                              ? Colors.white
                                              : null,
                                        ),
                                        child: Text(choice!),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Display the score only when the quiz is submitted
                if (quizSubmitted)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Your score is ${((score / questions.length) * 100.0)}%',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 400,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(48, 60, 84, 1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                            primary: Color.fromRGBO(143, 66, 179, 1)),
                        onPressed: quizSubmitted ? retakeQuiz : submitQuiz,
                        child: Text(quizSubmitted ? 'Retake Quiz' : 'Submit'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class Question {
  final String questionText;
  final String questionId;
  List<dynamic> answerChoices = ["no answers"];
  String? correctAnswer;

  Question(this.questionText, this.questionId);
}
