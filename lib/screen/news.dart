import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsScreen extends StatelessWidget {
  final String title;
  final String createdAt;
  final String content;
  // final String updatedAt;

  NewsScreen(this.title, this.createdAt, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              createdAt,
              style: TextStyle(fontFamily: 'arial'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Html(data: content),
          ],
        ),
      )
    );
  }
}