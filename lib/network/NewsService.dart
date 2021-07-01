import 'package:news/model/News.dart';
import 'api.dart';
import 'dart:convert';

class NewsService {
  static String baseUrl = '/news';

  static Future<List<News>> fetchNews() async {
    final response = await Network().getData(baseUrl);
    List<News> list = jsonDecode(response.body);
    return list;
  }
}