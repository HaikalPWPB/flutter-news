import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/model/News.dart';
import 'package:news/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news/screen/news.dart';
import 'package:news/screen/search.dart';

Future _getNews() async {
  var response = await http.get(Uri.parse('http://192.168.100.165:8000/api/v1/news'));
  var jsonData = jsonDecode(response.body);
  List<News> news = [];

  for(var a in jsonData) {
    News post = News(a['title'], a['content'], a['created_at'], a['updated_at']);
    news.add(post);
  }
  print(news.length);
  return news;
}

Future _getUser() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var user = localStorage.getString('user');
  print(user);
  Map<String, dynamic> jsonUser = jsonDecode(user);
  return jsonUser;
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  var user;

  final List<Widget> _children = [
      Container(
        child: Card(
          child: FutureBuilder(
            future: _getNews(),
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(snapshot.data[i].title),
                      subtitle: Text(snapshot.data[i].createdAt),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsScreen(
                            snapshot.data[i].title, snapshot.data[i].createdAt, snapshot.data[i].content
                          ))
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        )
      ),
    Container(
        child: Column(
          children: [
            // Card(
            //   child: FutureBuilder(
            //     future: _getUser(),
            //     builder: (context, snapshot) {
            //       if(snapshot.data == null) {
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }else {
            //         return Text(snapshot.data.email);
            //       }
            //     },
            //   ),
            // ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Network().logout();
                // Navigator.push(context, route)
              },
            )
          ],
        )
      ),
  ];

  @override
  void initState() {
    setState(() {
      user = _getUser();
    });
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Flutter'),
        backgroundColor: Color(0xffe46b10),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.cyan,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'User Profile'
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => SearchScreen()
            )
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}