import 'package:flutter/material.dart';
import 'package:news/network/user_service.dart';
import 'package:news/network/api.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: UserService().getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          CircleAvatar(
                            radius: 50,
                            child: Text(
                              snapshot.data['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontFamily: 'arial'
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            snapshot.data['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35
                            ),
                          ),
                          Text(
                            snapshot.data['email'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Georgia',
                              fontSize: 15
                            ),
                          ),
                          Divider(
                            height: 20,
                          ),
                        ],
                      );
                    }
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      child: Text('Logout'),
                      onPressed: () {
                        Network().logout();
                        Navigator.pushReplacementNamed(context ,'/login');
                      },
                    );
                  }
                )
              ],
            ),
          )
        ),
      )
    );
  }
}