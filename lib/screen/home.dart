import 'package:flutter/material.dart';
import 'package:news/screen/search.dart';
import 'package:news/helper/date.dart';
import 'package:news/network/user_service.dart';
import 'package:news/network/firebase_service.dart';
import 'package:news/widget/news_list.dart';
import 'package:news/widget/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _message = '';
  int _currentIndex = 0;
  var user;
  Date date = new Date();
  
  //Instance of firebase services
  FirebaseService firebaseService = FirebaseService();

  final List<Widget> _children = [
    NewsList(),
    Profile()
  ];

  @override
  void initState() {
    firebaseService.registerOnFirebase();
    firebaseService.getMessage();
    setState(() {
      user = UserService().getUser();
    });
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Flutter'),
        backgroundColor: Colors.cyan,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.cyan,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Read News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user), label: 'User Profile')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
