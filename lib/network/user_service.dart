import 'dart:convert';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends Network {
  Future getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    Map<String, dynamic> jsonUser = jsonDecode(user);

    return jsonUser;
  }
}