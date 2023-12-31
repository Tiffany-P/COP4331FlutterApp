import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'flashcardsPage.dart';

String userId = '';

class myQuizzesPage extends StatefulWidget {
  String id;

  myQuizzesPage({super.key, required this.id}) {
    userId = id;
  }

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<myQuizzesPage> {
  List<dynamic> quizList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    print("userid$userId");
    fetchQuizNames();
  }

  Future<void> fetchQuizNames() async {
    final response = await http.post(
      Uri.parse(
          'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/quizzes/getfromuser'),
      body: json.encode({'userId': userId, 'public': false}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      //final List<dynamic> data = json.decode(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      print("Search my quizzes:");
      print(data['result']);

      if (data['result'] != null && data['result'][0]['Name']!= null) {
        setState(() {
          quizList = data['result']
              .map((e) => {
                    
                    'QuizId': e['_id'],
                    'QuizName': e['Name'],
                  })
              .toList();
          isLoading = false;
        });
      }
        else {
          setState(() {
          isLoading = false;
      });
    }
    } else {
      print("uh oh ${response.statusCode}");
      isLoading = false;
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
        crossAxisAlignment: CrossAxisAlignment.start, // Left-align the title
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Quizzes', // Replace with your desired title
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: (quizList.length > 0) ? ListView.builder(
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
            )
            : const SizedBox(
                  child: Center(
                  child: Text("No Created Quizzes", 
                  style: TextStyle(
              color: Color.fromARGB(175, 255, 255, 255),
              fontSize: 20,
              fontWeight: FontWeight.bold,)),
                  ),
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

  const FlashCardWidget(
      {super.key, required this.quizId, required this.quizName});

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
        margin: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color.fromARGB(255, 86, 17, 183),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12.0), // Set corner radius to 12 for rounded corners
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  quizName,
                  style: const TextStyle(
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
