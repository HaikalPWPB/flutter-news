import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/model/News.dart';
import 'package:news/network/api.dart';
import 'package:news/network/NewsService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future _getNews() async {
    var response = await http.get(Uri.parse('http://192.168.100.165:8000/api/news'));
    var jsonData = jsonDecode(response.body);
    List<News> news = [];

    for(var a in jsonData) {
      News post = News(a['title'], a['content'], a['created_at'], a['updated_at']);
      news.add(post);
    }
    print(news.length);
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Flutter'),
        backgroundColor: Color(0xffe46b10),
      ),
      body: Container(
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
                      title: Text(snapshot.data[i].title)
                    );
                  },
                );
              }
            },
          ),
        )
      )
    );
  }
}

// class ItemList extends StatelessWidget {
//   final List<News> list;
//   ItemList({required this.list});

//   @override 
//   Widget build(BuildContext context) {
//     return new ListView.builder(
//       itemCount: list == null ? 0 : list.length,
//       itemBuilder: (context, i){
//         return Text(list[i].content);
//       }
//     );
//   }
// }