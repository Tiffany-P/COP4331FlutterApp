import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class FlashcardPage extends StatefulWidget {
  final String quizId;
  final String name;
  final String userId;

  FlashcardPage({super.key, required this.quizId, required this.name, required this.userId}) {
    print('Quiz ID in constructor: $quizId');
  }

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> with SingleTickerProviderStateMixin{
  // Add your flashcard logic here
  List<Flashcard> flashcards = [];
  List<Flashcard> questionIDs = [];
  int currentIndex = 0;

  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    fetchQuestions(widget.quizId);
  }

  Future<void> fetchQuestions(String quizId) async {
    print('Quiz ID in fetch questions: $quizId');
    const String apiUrl =
      'http://10.0.2.2:5000/api/questions/get';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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

    _carouselController.nextPage();
  }

  void prevCard() {
   
    setState(() {
      currentIndex = (currentIndex - 1) % flashcards.length;
      fetchAnswerAndFlipCard(false);
    });

    _carouselController.previousPage();
  }


Future<void> addQuiz() async {
    print('Quiz ID in add quiz: ${widget.quizId}');
    print('User ID in add quiz: ${widget.userId}');
    String userId = widget.userId;
    String quizId = widget.quizId;
    const String apiUrl =
      'http://10.0.2.2:5000/api/saved/add';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'userId': userId, 'quizId': quizId}),
      );

  
      if (response.statusCode == 200) {
        print("Quiz Added:");
       
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Quiz Saved"),
        ));
        /*Fluttertoast.showToast(
          msg: "Quiz Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 20,
          fontSize: 16.0,
        );

        */
       
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flashcards'),
          backgroundColor: const Color.fromARGB(255, 86, 17, 183)),
      backgroundColor: const Color.fromRGBO(67, 39, 161, 1),
      body: Center(
        child: Column(
          children: [
            Container(
            margin: const EdgeInsets.only(top: 50.0, bottom: 100, left: 30),
            child: Align(
              alignment: Alignment.topLeft,
            
                child: Text(widget.name, 
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
                    ),
                ),
            ),
            if (flashcards.isNotEmpty && currentIndex < flashcards.length)
            GestureDetector(
            child: Center(
            child: CarouselSlider.builder(
          itemCount: flashcards.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return FlashcardWidget(
                flashcard: flashcards[currentIndex],
                onToggle: () => fetchAnswerAndFlipCard(true),
              );
          },
          options: CarouselOptions(
            height: 250.0,
            viewportFraction: 0.9,
            initialPage: 0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
              // Row(children: [
              IconButton(
                iconSize: 50.0,
                color: Colors.white,
                icon: const Icon(Icons.arrow_circle_left_outlined),
                onPressed: () => prevCard(),
              ),
              const Padding(padding: EdgeInsets.only(right: 10)),
             // (flashcards.length == 0) ?
                 Text( (flashcards.isEmpty) ?
                "$currentIndex /${flashcards.length}" : "${currentIndex + 1}/${flashcards.length}",    
               style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),),
              const Padding(padding: EdgeInsets.only(left: 10)), 
              IconButton(
                iconSize: 50.0,
                color: Colors.white,
                icon: const Icon(Icons.arrow_circle_right_outlined),
                onPressed: () => nextCard(),
              ),
            ]),
            const SizedBox(height: 30.0),
            ElevatedButton(
                onPressed: () {
                  addQuiz();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(48, 60, 84, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                     
                    ),
                  ),
                ),
                child: const Text('Save Quiz'),
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

  const FlashcardWidget({super.key, required this.flashcard, required this.onToggle});

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color
   ),  
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
