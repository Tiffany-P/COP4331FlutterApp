import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

import 'test.dart';

//import 'package:fluttertoast/fluttertoast.dart';
// public to false, userId
String user = '';
String quiz = '';
bool savedQuiz = false;

class FlashcardPage extends StatefulWidget {
  final String quizId;
  final String name;
  final String userId;

  FlashcardPage(
      {super.key,
      required this.quizId,
      required this.name,
      required this.userId}) {
    print('Quiz ID in constructor: $quizId');
    user = userId;
    quiz = quizId;
  }

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> with SingleTickerProviderStateMixin {
  // Add your flashcard logic here
  List<dynamic> flashcards = [];
  List<dynamic> questionIDs = [];
  int currentIndex = 0;

  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    checkIfSavedQuiz(widget.quizId);
    fetchQuestions(widget.quizId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // This block will be executed when the widget is displayed again
    refreshState();
  }

  void refreshState() {
    setState(() {
      // Update the state as needed
      savedQuiz = false;
    });
  }

  Future<void> fetchQuestions(String quizId) async {
    print('Quiz ID in fetch questions: $quizId');
    const String apiUrl = 'http://cop4331-27-c6dfafc737d8.herokuapp.com/api/questions/search';
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

        print("Quiz Data:");
        print(data['result']);

        setState(() {
          flashcards = data['result']
              .map((item) => Flashcard(item['Question'], item['_id']))
              .toList();
          // flashcards = data.map((item) => Flashcard(item['_id'])).toList();
        });
 
        print("Getting answer:");
        for (dynamic flashcard in flashcards) {
          final answer = await fetchAnswer(flashcard.questionId);
          setState(() {
            flashcard.answer = answer;
          });
        }
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

  Future<void> FlipCard(bool flip) async {
    print("flipping :");
    if (currentIndex < flashcards.length) {
    
      setState(() {
        if (flip == false) {
          flashcards[currentIndex].isFlipped = false;
        } else if (flip == true) {
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
    print("API answers for questiond id:$questionId");
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:5000/api/answers/get'),
    //   body: json.encode({'questionId': questionId}),
    //   headers: {'Content-Type': 'application/json'},
    // );

    final response = await http.post(
      Uri.parse('http://cop4331-27-c6dfafc737d8.herokuapp.com/api/answers/get'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'questionId': questionId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print("Quiz Data Answers:");
      print(data['result']);

      /* List<dynamic> res2 = data['result']
              .map((e) => {
                    
                  e['Answer']
                  })
              .toList();
      print("RES2 $res2");*/
      List<dynamic> results = data['result'];

      String name = results[0]['Answer'].toString();
     
      return name;
    }
    return 'Answer not found';
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      FlipCard(false);
    });

    _carouselController.nextPage();
  }

  void prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1) % flashcards.length;
      FlipCard(false);
    });

    _carouselController.previousPage();
  }

  Future<void> checkIfSavedQuiz(String quizId) async {
    final response = await http.post(
      Uri.parse('http://cop4331-27-c6dfafc737d8.herokuapp.com/api/saved/get'),
      body: json.encode({'id': user}),
      headers: {'Content-Type': 'application/json'},
    );

    print("check if saved");
    if (response.statusCode == 200) {
      List<dynamic> quizList = [];
      final Map<String, dynamic> data = json.decode(response.body);
      print("Quiz Data in Check Saved:");
      print(data);

      setState(() {
        quizList = data['result']
              .map((e) => {
                    'QuizId': e['_id'],
                  })
              .toList();
      });

      // Only fetch quiz names if there are saved quizzes
      if (quizList.isNotEmpty) {
        for (final quiz in quizList) {
          if (quiz['QuizId'] == quizId) {
            savedQuiz = true;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flashcards'),
          backgroundColor: const Color.fromARGB(255, 86, 17, 183)),
      backgroundColor: const Color.fromRGBO(67, 39, 161, 1),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40.0, bottom: 45, left: 30),
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
            Row(mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              const Padding(padding: EdgeInsets.only(left: 40)),
              ToggleButton(),
              const Padding(padding: EdgeInsets.only(left: 20)),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(48, 60, 84, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  TestPage(id: widget.quizId,)),
                  );
                },
                child: Text("Take Test"),
              ),
            ]
            ),
            const SizedBox(height: 20.0),
            if (flashcards.isNotEmpty && currentIndex < flashcards.length)
              GestureDetector(
                child: Center(
                  child: CarouselSlider.builder(
                    itemCount: flashcards.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return FlashcardWidget(
                        flashcard: flashcards[currentIndex],
                        onToggle: () => FlipCard(true),
                      );
                    },
                    options: CarouselOptions(
                      height: 250.0,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      pageSnapping: true,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    carouselController: _carouselController,
                  ),
                ),
              ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Row(children: [
              IconButton(
                iconSize: 50.0,
                color: Colors.white,
                icon: const Icon(Icons.arrow_circle_left_outlined),
                onPressed: () => prevCard(),
              ),
              const Padding(padding: EdgeInsets.only(right: 10)),
              // (flashcards.length == 0) ?
              Text(
                (flashcards.isEmpty)
                    ? "$currentIndex /${flashcards.length}"
                    : "${currentIndex + 1}/${flashcards.length}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              IconButton(
                iconSize: 50.0,
                color: Colors.white,
                icon: const Icon(Icons.arrow_circle_right_outlined),
                onPressed: () => nextCard(),
              ),
            ]),
            const SizedBox(height: 30.0),
            Container(
              width: 400,
              height: 400,
              child: CardList(flashcards),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool isToggled = false;

  Future<void> addQuiz() async {
    print('Quiz ID in add quiz: ${quiz}');
    print('User ID in add quiz: ${user}');

    const String apiUrl = 'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/saved/add';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': user, 'quizId': quiz}),
      );

      if (response.statusCode == 200) {
        print("Quiz Added:");

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Quiz Saved"),
        ));
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

  Future<void> deleteQuiz() async {
    print('Quiz ID in delete quiz: ${quiz}');
    print('User ID in delete quiz: ${user}');

    const String apiUrl =
        'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/saved/delete';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'userId': user, 'quizId': quiz}),
      );

      if (response.statusCode == 200) {
        print("Quiz Deleted from Saved:");

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Quiz Removed"),
        ));
        savedQuiz = false;
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

  void _toggleButton() {
    setState(() {
      savedQuiz = !savedQuiz;

      // Perform different actions based on the button state
      if (savedQuiz) {
        // Do something when the button is toggled
        print('Button is Toggled');
        addQuiz();

      } else {
        // Do something else when the button is not toggled
        print('Button is Not Toggled');
        deleteQuiz();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: savedQuiz
            ? MaterialStateProperty.all<Color>(Color.fromRGBO(22, 25, 33, 1))
            : MaterialStateProperty.all<Color>(
                const Color.fromRGBO(48, 60, 84, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: _toggleButton,
      child: Text(savedQuiz ? 'Saved' : 'Save Quiz'),
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

  const FlashcardWidget(
      {super.key, required this.flashcard, required this.onToggle});

  @override
  // ignore: library_private_types_in_public_api
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
        duration: const Duration(milliseconds: 500),
        child: widget.flashcard.isFlipped
            ? CardSide(
                text: widget.flashcard.answer,
                color: const Color.fromRGBO(48, 60, 84, 1))
            : CardSide(
                text: widget.flashcard.question,
                color: const Color.fromRGBO(48, 60, 84, 1)),
      ),
    );
  }
}

class CardSide extends StatelessWidget {
  final String? text;
  final Color color;

  const CardSide({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 240,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adjust padding as needed
          child: Text(
            text ?? '',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  List<dynamic> flashcards;
  CardList(this.flashcards, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        return CardItem(
          term: flashcards[index].question.toString(),
          definition: flashcards[index].answer.toString()
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final String term;
  final String definition;

  CardItem({required this.term, required this.definition});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(48, 60, 84, 1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                term,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                definition as String,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
