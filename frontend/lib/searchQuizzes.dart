import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:quiz_app/quiz_model.dart';
import 'dart:convert';
import 'register.dart';

class Item {
  final String term;
 
  Item({required this.term});

  Map<String, dynamic> toJson() => {
      'term': term,
    };
}

class QuizModel {
  String? quiz_title;
  String? author;

  QuizModel(this.quiz_title, this.author);
}

class ItemService {
  final String apiUrl = 'https://cop4331-27-c6dfafc737d8.herokuapp.com/api/quizzes/search';  // Replace with your API endpoint
  
  Future<Map<String, dynamic>> searchItems(String query) async {
   // List<Map<String, dynamic>> map = [];
   
  final item = Item(term: query);
  final userJson = jsonEncode(item);

  print("Term: $query");

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: userJson,
    );

    if (response.statusCode == 200) {

     final Map<String, dynamic> res = json.decode(response.body);
      print(res);
      return res;
     
    
    } else {
      throw Exception('Failed to load items');
    }
    }
    catch (e) {
    // Handle network or server connection issues.
    print('Error: $e');

  }
  throw Exception('Failed to return');
  }

}
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  // fake list, this will be deleted later
  static List<QuizModel> main_quizzes_list = [
    QuizModel("Planets", "Planet Lover"),
    QuizModel("Cars", "Lightning McQueen"),
    

  ];
  // creating  list that will be displayed and filter
  List<QuizModel> display_list = List.from(main_quizzes_list);
  void updateList(String value) {
    
    setState(() {
      display_list = main_quizzes_list.where((element) => 
        element.quiz_title!.toLowerCase().contains(value.toLowerCase())).toList();
    });
    
  }

  final ItemService _itemService = ItemService();
  List<Item> _searchResults = [];

  void _searchItems(String query) async {
    Map<String, dynamic> results = await _itemService.searchItems(query);
    //setState(() {
   //   print(results);
    //});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuizWizz'),
        backgroundColor: Color.fromARGB(255, 86, 17, 183),
        
        
      ),
      backgroundColor: Color.fromARGB(255, 41, 5, 73),
      body: Padding(padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Search for a Quiz", style: TextStyle(
              color: Colors.white, 
              fontSize: 22.0,
              fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) => updateList(value),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 91, 73, 158),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none
                  ),
                
                hintText: "eg. Plants ",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.purple.shade900
                ),
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: display_list.length == 0 ? const Center(child: Text("No results found", style: TextStyle(
                color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold
                  ),
              ))
              : ListView.builder(
                itemCount: display_list.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(display_list[index].quiz_title!, style: 
                  TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text('By: ${display_list[index].author}', 
                style: TextStyle(
                  color: Colors.white60,
                ),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}