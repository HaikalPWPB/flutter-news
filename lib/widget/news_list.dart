import 'package:flutter/material.dart';
import 'package:news/network/news_service.dart';
import 'package:news/screen/news.dart';
import 'package:news/helper/date.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: FutureBuilder(
        future: NewsService().getNews(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(snapshot.data[i].title),
                      subtitle: Text('Di upload pada: ${Date.formatDate(snapshot.data[i].createdAt)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsScreen(
                              snapshot.data[i].title,
                              Date.formatDate(snapshot.data[i].createdAt),
                              snapshot.data[i].content
                            )
                          )
                        );
                      },
                    ),
                  )
                );
              },
            );
          }
        },
      ),
    );
  }
}