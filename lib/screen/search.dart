import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:news/model/News.dart';
import 'package:http/http.dart' as http;
import 'package:news/screen/news.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news/helper/date.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final SearchBarController<News> _searchBarController = SearchBarController();
  bool _isReplay = false;

  Future<List<News>> _getNews(String keyword) async {
    // Post text to laravel api
    print(keyword);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('token'))['token'];
    var response = await http.post(
        Uri.parse('https://haikal.cyberwarrior.co.id/api/v1/news/search'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{
            'keyword': keyword
          }),
        );
        
    if(response.statusCode == 200) {
      print('Hello world');
    }
    var jsonData = jsonDecode(response.body);
    print(jsonData.length);
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.symmetric(horizontal: 10),
            placeHolder: Text('Search by title...'),
            cancellationWidget: Icon(Icons.cancel),
            searchBarController: _searchBarController,
            onSearch: _getNews,
            onItemFound: (News news, int index) {
              return Container(
                child: ListTile(
                  title: Text(news.title),
                  subtitle: Text(Date.formatDate(news.createdAt)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewsScreen(
                        news.title,
                        Date.formatDate(news.createdAt),
                        news.content
                      ))
                    );
                  },
                ),
              );
            },
            onCancelled: () {
              print('Cancelled');
            },
          ),
        ),
      ),
    );
  }
}