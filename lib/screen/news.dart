import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

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
              'Di Upload Pada: $createdAt',
              style: TextStyle(fontFamily: 'arial'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Html(
              data: content,
              //onLinkTap here
              onLinkTap: (String url, RenderContext context, Map<String, String> attributes, dom.Element element) {
                //open URL in webview, or launch URL in browser, or any other logic here
                print(url);
                print(element);
                print(attributes);
                launch(url);
              } 
            ),
          ],
        ),
      )
    );
  }
}