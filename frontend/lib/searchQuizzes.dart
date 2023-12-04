import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'flashcardsPage.dart';

String userId = '';

class Item {
  final String term;
  final String id;

  const Item({
    required this.term,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] as String,
      term: json['Name'] as String,
    );
  }
}

class ItemService {
  final String apiUrl =
      'http://cop4331-27-c6dfafc737d8.herokuapp.com/api/quizzes/search'; // Replace with your API endpoint

  Future<List> searchItems(String query) async {
    print("Term: $query");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'term': query}),
      );

      if (response.statusCode == 200) {
        print(query);

        final Map<String, dynamic> data = json.decode(response.body);

        print("Search Answers:");
        print(data['result']);
        List<dynamic> allPostList =
            data['result'].map((e) => Item.fromJson(e)).toList();
        return allPostList;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      // Handle network or server connection issues.
      print('Error: $e');
    }
    throw Exception('Failed to load items');
  }
}

class SearchPage extends StatefulWidget {
  final String id;

  SearchPage({super.key, required this.id}) {
    userId = id;
  }

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ItemService _itemService = ItemService();

  List<dynamic> _searchResults = [];

  void _searchItems(String query) async {
    if (query != '') {
      List<dynamic> results = (await _itemService.searchItems(query));
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = List.empty();
      });
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
        backgroundColor: const Color.fromARGB(255, 86, 17, 183),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 5, 73),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Search for a Quiz",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (query) => _searchItems(query),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 107, 88, 178),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none),
                  hintText: "eg. Plants ",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: const Color.fromARGB(255, 41, 10, 79)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(
                      child: Text(
                      "No results found",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ))
                  : Container(
                      //margin: const EdgeInsets.all(4.0),
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlashcardPage(
                                    quizId: _searchResults[index].id,
                                    name: _searchResults[index].term,
                                    userId: userId,
                                  ),
                                ),
                              );
                              // Handle the tap, you can navigate to another screen or perform any action with the quizId
                              print('Tapped on Quiz ID: ');
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
                                        _searchResults[index].term,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
