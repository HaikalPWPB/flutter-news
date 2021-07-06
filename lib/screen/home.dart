import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/model/News.dart';
import 'package:news/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news/screen/news.dart';
import 'package:news/screen/search.dart';
import 'package:news/main.dart';
import 'package:news/helper/date.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
);

Future _getNews() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = jsonDecode(localStorage.getString('token'))['token'];
  // var response = await http.get(
  //     Uri.parse('https://haikal.cyberwarrior.co.id/api/v1/news'),
  //     headers: {'Authorization': 'Bearer $token'});
  var response = await Network().getData('/news');
  var jsonData = jsonDecode(response.body);
  List<News> news = [];

  for (var a in jsonData) {
    News post =
        News(a['title'], a['content'], a['created_at'], a['updated_at']);
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
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _message = '';
  int _currentIndex = 0;
  var user;
  Date date = new Date();

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) => print('haha: $token'));
  }

  @override
  void initState() {
    _registerOnFirebase();
    getMessage();
    setState(() {
      user = _getUser();
    });
    super.initState();
  }

  void getMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      FlutterLocalNotificationsPlugin  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      if(notification != null && android != null) {
        print(notification.title);
        print(notification.body);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'launch_background',
            )
          )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
      print('OnMessageOpenedApp');
    });
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

  final List<Widget> _children = [
    Container(
      margin: EdgeInsets.all(10),
      child: FutureBuilder(
        future: _getNews(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(snapshot.data[i].title),
                      subtitle: Text('Di upload pada: ${Date.formatDate(snapshot.data[i].createdAt)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsScreen(
                              snapshot.data[i].title,
                              Date.formatDate(snapshot.data[i].createdAt),
                              snapshot.data[i].content
                            )
                          )
                        );
                      },
                    ),
                  )
                );
              },
            );
          }
        },
      ),
    ),
    Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Card(
        child: Column(
          children: [
            FutureBuilder(
              future: _getUser(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      CircleAvatar(
                        radius: 50,
                        child: Text(
                          snapshot.data['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontFamily: 'arial'),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        snapshot.data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      Text(
                        snapshot.data['email'],
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Georgia',
                            fontSize: 15),
                      )
                    ],
                  );
                }
              },
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Network().logout();
                // Navigator.push(context, route)
                navigatorKey.currentState.pushReplacementNamed('/login');
              },
            )
          ],
        ),
      )
    )
  ];


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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
