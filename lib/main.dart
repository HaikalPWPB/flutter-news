import 'package:flutter/material.dart';
import 'package:news/screen/login.dart';
import 'package:news/screen/home.dart';
import 'package:news/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/' : (context) => HomeScreen(),
        '/login' : (context) => LoginScreen(),
        '/register' : (context) => RegisterScreen()
      },
    );
  }
}

// class CheckAuth extends StatefulWidget {
//   @override
//   _CheckAuthState createState() => _CheckAuthState();
// }

// class _CheckAuthState extends State<CheckAuth> {
//   bool isAuth = false;
//   @override
//   void initState() {
//     _checkIfLoggedin();
//     super.initState();
//   }

//   void _checkIfLoggedIn() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var token = localStorage.getString('token');
//     if(token != null){
//       setState(() {
//         isAuth = true;
//       });
//     } 
//   }

//   @override
//   Widget build(BuildContext context){
//     Widget child;
//     if(isAuth){
//       child = Home();
//     }else{
//       child = Login();
//     }
//     return Scaffold(
//       body: child,
//     )
//   }
// }

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.pushNamed(context, '/third');
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Third Route')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!')),
        ),
    );
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Title',
//       home: MyWidget(),
//     );
//   }
// }

// class MyWidget extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Hello world'));
//   }
// }

// Future<Album> fetchAlbum() async {
//   final response = await  http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  
//   if(response.statusCode == 200){
//     return Album.fromJson(jsonDecode(response.body));
//   }else{
//     throw Exception('Failed to load album');
//   }
// }

// class Album {
//   final int userId;
//   final int id;
//   final String title;

//   Album({
//     required this.userId,
//     required this.id,
//     required this.title,
//   });

//   factory Album.fromJson(Map<String, dynamic> json){
//     return Album(userId: json['userId'], id: json['id'], title: json['title']);
//   }
// }

// class MyApp extends StatefulWidget{
//   MyApp({Key? key}) : super(key:key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp>{
//   late Future<Album> futureAlbum;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch data example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Fetch data example'),
//         ),
//         body: Center(
//           child: FutureBuilder<Album>(
//             future: futureAlbum,
//             builder: (context, snapshot) {
//               if(snapshot.hasData){
//                 return Text(snapshot.data!.title);
//               }else if(snapshot.hasError){
//                 return Text("${snapshot.error}");
//               }

//               return CircularProgressIndicator();
//             }
//           )
//         ),
//       )
//     );
//   }
// }