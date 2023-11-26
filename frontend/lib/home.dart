import 'package:flutter/material.dart';
import 'package:quiz_app/default.dart';
import 'myQuizzes.dart';
import 'searchQuizzes.dart';
import 'flashcardsPage.dart';
import 'savedQuizzes.dart';

class HomePage extends StatefulWidget {
  final String id;
  final String userName;
  
  const HomePage(this.id, this.userName, {super.key});

 @override
  _HomePageState createState() => _HomePageState(id, userName);
}

class _HomePageState extends State<HomePage> {
  String selectedOption = 'Option 1';
  final String userId, userName;

  _HomePageState(this.userId, this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(userId, userName),
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', width: 120, height: 140,),
        backgroundColor: const Color.fromARGB(255, 86, 17, 183),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => SearchScreen()),
                    MaterialPageRoute(builder: (context) => SearchPage(id: userId)),
                  );
                },
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected option
              print('Selected: $value');
              if(value =='option1') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'option1',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(31, 24, 79, 1),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 30.0),
          const Text(
            '   Popular',
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 23, // Set text font size
            ),
          ),
          const SizedBox(height: 10.0),
          ContainerWithBoxes('popular', userId),
          const SizedBox(height: 30.0),
          const Text(
            '   Suggested',
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 23, // Set text font size
            ),
          ),
          const SizedBox(height: 10.0),
          ContainerWithBoxes('suggested', userId),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Clear user session data (e.g., token, user info)
    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DefaultPage(),
      ),
    );
  }
}

List<BoxInfo> getListInfo(String option) {

    final List<BoxInfo> boxInfoList;
    if(option == 'popular') {
      boxInfoList = [

      BoxInfo(id: '65249bd5a5a3366c6ede8722', title: 'Plants', description: '', color: const Color.fromRGBO(79, 37, 133, 1)),
      BoxInfo(id: '65249b97a5a3366c6ede8721', title: 'Mammals', description: '', color: const Color.fromRGBO(79, 37, 133, 1)),
      BoxInfo(id: '65249bf3a5a3366c6ede8723', title: 'Sea Life', description: '', color: const Color.fromRGBO(79, 37, 133, 1)),

        // Add more BoxInfo items as needed
      ];
    }
    else {
       boxInfoList = [
        // these are fake quizzes that have the plants id for now. replace id with actual id
        BoxInfo(id: '65249bd5a5a3366c6ede8722', title: 'Title', description: '', color: const Color.fromRGBO(79, 37, 133, 1)),
        BoxInfo(id: '65249bd5a5a3366c6ede8722', title: "Title", description: '', color: const Color.fromRGBO(79, 37, 133, 1)),
        BoxInfo(id: '65249bd5a5a3366c6ede8722', title: 'Title', description: '', color: const Color.fromRGBO(79, 37, 133, 1)),
        // Add more BoxInfo items as needed
      ];
    }

    return boxInfoList;
}

class ContainerWithBoxes extends StatelessWidget {
  late final List<BoxInfo> boxInfoList;
  final String userId;
  
  ContainerWithBoxes(String option, this.userId, {super.key}){

    boxInfoList = getListInfo(option);
  }
 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0, // Set the desired height
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromRGBO(31, 24, 79, 1),
      child: ListView.builder(
     
        
        scrollDirection: Axis.horizontal,
        itemCount: boxInfoList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
            context, MaterialPageRoute(
                builder: (context) => FlashcardPage(quizId: boxInfoList[index].id, name:  boxInfoList[index].title, userId: userId,),
                ),
              );
            },
            child: BoxItem(boxInfo: boxInfoList[index]),
          );
        },
      ),
    );
  }
}

class BoxInfo {
  final String title;
  final String description;
  final Color color;
  final String id;

  BoxInfo({required this.id, required this.title, required this.description, required this.color});
}

class BoxItem extends StatelessWidget {
  final BoxInfo boxInfo;

  const BoxItem({super.key, required this.boxInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: boxInfo.color,
        border: Border.all(
              color: Color.fromARGB(200, 155, 141, 18), // Specify the color of the border
              width: 2.0, // Specify the width of the border
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            boxInfo.title,
            style: const TextStyle(
              fontSize: 18.0, 
              fontWeight: FontWeight.bold, 
              color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          Text(
            boxInfo.description,
            style: const TextStyle(fontSize: 14.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final String userId;
  final String userName;
  const DrawerWidget(this.userId, this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 129, 160, 247),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(''),
            accountEmail: Text(userName, style: const TextStyle(fontSize: 20.0)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("assets/images/wizardicon.png",
                width: 90,
                height: 90,
                fit: BoxFit.cover)
                ),

            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 86, 17, 183),
              image: DecorationImage(
                  image: AssetImage("assets/images/magicSparkles.jpg"),
                     fit: BoxFit.cover)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved Quizzes'),
            selectedTileColor: const Color.fromARGB(255, 86, 17, 183),
           
            onTap: () {
              // Navigate to the home page or perform an action
              Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => SearchScreen()),
                    MaterialPageRoute(builder: (context) =>  savedQuizzesPage(id: userId,)),
                  );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shelves),
            title: const Text('My Quizzes'),
            onTap: () {
               Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => SearchScreen()),
                    MaterialPageRoute(builder: (context) =>  myQuizzesPage(id: userId,)),
                  );
            },
          ),
          // Add more ListTile items for additional menu options
        ],
      ),
    );
  }
}
