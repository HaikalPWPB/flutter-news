import 'package:news/model/News.dart';
import 'api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
}