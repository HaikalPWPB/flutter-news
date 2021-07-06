import 'api.dart';
import 'dart:convert';
import 'package:news/model/News.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static String baseUrl = '/news';

  Future getNews() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('token'))['token'];
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

    Future<List<News>> searchNews(String keyword) async {
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
}