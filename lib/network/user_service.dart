import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    print(user);
    Map<String, dynamic> jsonUser = jsonDecode(user);
    return jsonUser;
}
}