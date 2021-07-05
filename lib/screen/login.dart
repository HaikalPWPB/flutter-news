import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news/network/api.dart';
import 'package:news/screen/home.dart';
import 'package:news/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news/helper/validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final email = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _showAlert(msg) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Failed'),
          content: Text(msg),
        );
      }
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(top: 100.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Text(
                      'Login',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.cyan),
                    ),
                ),
                SizedBox(
                  height: 48,
                ),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: validateEmail
                ),
                // TextField(
                //   controller: email,
                //   obscureText: false,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Email',
                //   ),
                // ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: validatePassword
                ),
                // TextField(
                //   controller: password,
                //   obscureText: true,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Password',
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text('Not have an account? Create here!', 
                        style: TextStyle(color: Colors.cyan),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen())
                        );
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      _isLoading ? '...Loading' : 'Login'
                    ),
                    color: Colors.cyan,
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in...')));
                        _login();
                      }
                    },
                  )
                ),
              ],
            ),
          )
        )
      )
    );
  }
  
  void _login () async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': email.text,
      'password': password.text,
    };

    // showDialog(context: context, builder: (context){
    //   return AlertDialog(
    //     title: Text('Login'),
    //     content: Text(email.text)
    //   );
    // });

    var res = await Network().authData(data, '/login');
    var body = jsonDecode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomeScreen()) 
      );
    }else{
      _showAlert(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}