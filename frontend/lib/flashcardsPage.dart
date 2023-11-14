import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlashcardPage extends StatefulWidget {
  final String quizId;

  FlashcardPage({required this.quizId}) {
    print('Quiz ID in constructor: $quizId');
  }

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  // Add your flashcard logic here
  List<Flashcard> flashcards = [];
  List<Flashcard> questionIDs = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions(widget.quizId);
  }

  Future<void> fetchQuestions(String quizId) async {
    print('Quiz ID in fetch questions: $quizId');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/questions/get'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'quizId': quizId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        print("Quiz Data:");
        print(data);

        setState(() {
          flashcards = data
              .map((item) => Flashcard(item['Question'], item['_id']))
              .toList();
          // flashcards = data.map((item) => Flashcard(item['_id'])).toList();
        });
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

  Future<void> fetchAnswerAndFlipCard(bool flip) async {
    print("fetching and flipping :");
    if (currentIndex < flashcards.length) {
      final questionId = flashcards[currentIndex].questionId;

      print("Getting answer:");
      final answer = await fetchAnswer(questionId);
      setState(() {
        flashcards[currentIndex].answer = answer;

        if (flip == false)
          flashcards[currentIndex].isFlipped = false;
        else if (flip == true) {
          if (flashcards[currentIndex].isFlipped == true) {
            flashcards[currentIndex].isFlipped = false;
          } else {
            flashcards[currentIndex].isFlipped = true;
          }
        }
      });
    }
  }

  Future<String> fetchAnswer(String questionId) async {
    print("API answers for questiond id:" + questionId);
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:5000/api/answers/get'),
    //   body: json.encode({'questionId': questionId}),
    //   headers: {'Content-Type': 'application/json'},
    // );

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/answers/get'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'questionId': questionId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print("Quiz Data Answers:");
      print(data);

      return data['Answer'];
    }
    return 'Answer not found';
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      fetchAnswerAndFlipCard(false);
    });
  }

  void prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1) % flashcards.length;
      fetchAnswerAndFlipCard(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Flashcards'),
          backgroundColor: Color.fromARGB(255, 86, 17, 183)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (flashcards.isNotEmpty && currentIndex < flashcards.length)
              FlashcardWidget(
                flashcard: flashcards[currentIndex],
                onToggle: () => fetchAnswerAndFlipCard(true),
              ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () => nextCard(),
                child: Text('Next Card'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 86, 2, 187)),
                ),
              ),
              // Row(children: [
              ElevatedButton(
                onPressed: () => prevCard(),
                child: Text('Prev Card'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 86, 2, 187)),
                ),
              ),
            ]),
            ElevatedButton(
              onPressed: () {},
              child: Text((currentIndex + 1).toString() +
                  "/" +
                  flashcards.length.toString()),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 86, 2, 187)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Flashcard {
  final String question;
  final String questionId;
  String? answer;
  bool isFlipped;

  Flashcard(this.question, this.questionId,
      {this.answer, this.isFlipped = false});
}

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onToggle;

  FlashcardWidget({required this.flashcard, required this.onToggle});

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onToggle(); // Call the callback to fetch answer and flip.
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: widget.flashcard.isFlipped
            ? CardSide(
                text: widget.flashcard.answer,
                color: Color.fromARGB(255, 218, 150, 255))
            : CardSide(
                text: widget.flashcard.question,
                color: Color.fromARGB(255, 218, 150, 255)),
      ),
    );
  }
}

class CardSide extends StatelessWidget {
  final String? text;
  final Color color;

  CardSide({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      alignment: Alignment.center,
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adjust padding as needed
          child: Text(
            text ?? '',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
