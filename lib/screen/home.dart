import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Flutter'),
        backgroundColor: Color(0xffe46b10),
      ),
      body: Container(
        child: Center(
          child: Text('Hello World, This is home screen'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}