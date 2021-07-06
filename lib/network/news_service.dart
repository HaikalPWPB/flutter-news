import 'api.dart';
import 'dart:convert';
import 'package:news/model/News.dart';

class NewsService extends Network {
  static String baseUrl = '/news';

  Future getNews() async {
    var response = await getData('/news');
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
    var data = {
      'keyword': keyword
    };

    var response = await postData(data, '/news/search');
        
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