import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:news/model/News.dart';
import 'package:http/http.dart' as http;
import 'package:news/screen/news.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final SearchBarController<News> _searchBarController = SearchBarController();
  bool _isReplay = false;

  Future<List<News>> _getNews(String keyword) async {
    // Post text to laravel api
    var response = await http.post(
          Uri.parse('http://192.168.11.40:8000/api/v1/news/search'),
          body: jsonEncode({
            'keyword': keyword
          })
        );
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
                  subtitle: Text(news.createdAt),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewsScreen(news.title, news.createdAt, news.content))
                    );
                  },
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}