// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'register.dart';

// class myQuizzesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QuizWizz'),
//         backgroundColor: Color.fromARGB(255, 86, 17, 183),
//         leading: GestureDetector(
//           onTap: () {/* Write listener code here */},
//           child: Icon(
//             Icons.menu, // add custom icons also
//           ),
//         ),
//         actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: Icon(
//                   Icons.search,
//                   size: 26.0,
//                 ),
//               )),
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: Icon(Icons.more_vert),
//               )),
//         ],
//       ),
//       backgroundColor: Color.fromARGB(255, 41, 5, 73),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const SizedBox(height: 30.0),
//           Text(
//             '   Popular',
//             style: TextStyle(
//               color: Colors.white, // Set text color to white
//               fontSize: 23, // Set text font size
//             ),
//           ),
//           const SizedBox(height: 30.0),
//           Text(
//             '   Suggested',
//             style: TextStyle(
//               color: Colors.white, // Set text color to white
//               fontSize: 23, // Set text font size
//             ),
//           ),
//           const SizedBox(height: 30.0),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'flashcardsPage.dart';

String userId = '';

class myQuizzesPage extends StatefulWidget {
  String id;

  myQuizzesPage({super.key, required this.id}){
    userId = id;
  }

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<myQuizzesPage> {
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    print("userid$userId");
    fetchQuizNames();
  }

  Future<void> fetchQuizNames() async {
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', width: 120, height: 140,),
        backgroundColor: const Color.fromARGB(255, 86, 17, 183),
      ),
      backgroundColor: const Color.fromARGB(255, 56, 17, 91),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left-align the title
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
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
                return FlashCardWidget(
                  quizId: quiz['QuizId'],
                  quizName: quiz['QuizName'],
                );
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

  const FlashCardWidget({super.key, required this.quizId, required this.quizName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FlashcardPage(quizId: quizId, name: quizName, userId: userId)),
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
