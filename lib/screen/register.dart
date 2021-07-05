import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news/network/api.dart';
import 'package:news/screen/home.dart';
import 'package:news/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news/helper/validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  final name = TextEditingController();
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
                      'Register',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.cyan),
                    ),
                ),
                SizedBox(
                  height: 48,
                ),
                TextFormField(
                  controller: name,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: validateName
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: email,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: validateEmail
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text('Already have an account?', 
                        style: TextStyle(color: Colors.cyan),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen())
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
                      _isLoading ? '...Loading' : 'Register'
                    ),
                    color: Colors.cyan,
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registering...')));
                        _register();
                      }
                    },
                  )
                )
              ],
            ),
          )
        )
      )
    );
  }
  
  void _register () async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'name' : name.text,
      'email': email.text,
      'password': password.text,
    };

    // showDialog(context: context, builder: (context){
    //   return AlertDialog(
    //     title: Text('Login'),
    //     content: Text(email.text)
    //   );
    // });

    var res = await Network().authData(data, '/register');
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