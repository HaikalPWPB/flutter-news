import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:news/model/News.dart';
import 'package:news/screen/news.dart';
import 'package:news/helper/date.dart';
import 'package:news/network/news_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final SearchBarController<News> _searchBarController = SearchBarController();
  bool _isReplay = false;

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
            placeHolder: Text('Search by title... (min first 4 character)'),
            cancellationWidget: Icon(Icons.cancel),
            searchBarController: _searchBarController,
            onSearch: NewsService().searchNews,
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