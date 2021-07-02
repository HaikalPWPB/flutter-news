import 'package:flutter/material.dart';
import 'package:news/screen/login.dart';
import 'package:news/screen/home.dart';
import 'package:news/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => LoginScreen(),
      },
      // onGenerateRoute: generateRoute,
      // darkTheme: ThemeData(brightness: Brightness.dark, ),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      setState(() {
        isAuth = true;
      });
    } 
  }

  @override
  Widget build(BuildContext context){
    Widget child;
    if(isAuth){
      child = HomeScreen();
    }else{
      child = LoginScreen();
    }
    return Scaffold(
      body: child,
    );
  }
}