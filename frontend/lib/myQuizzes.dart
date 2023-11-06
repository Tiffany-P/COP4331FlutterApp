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

final String userId = "653181459014bfbb8cff6c2c";

class myQuizzesPage extends StatefulWidget {
  // myQuizzesPage({required this.userId});

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<myQuizzesPage> {
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    print("userid" + userId);
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
        title: Text('Saved Quizzes'),
      ),
      body: ListView.builder(
        itemCount: quizList.length,
        itemBuilder: (context, index) {
          final quiz = quizList[index];
          return FlashCardWidget(quizId: quiz['QuizId']);
        },
      ),
    );
  }
}

class FlashCardWidget extends StatelessWidget {
  final String quizId;

  FlashCardWidget({required this.quizId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Quiz ID: $quizId',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
