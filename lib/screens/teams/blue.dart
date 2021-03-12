import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:red_blue/models/user.dart';
import 'package:red_blue/services/database.dart';

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}


class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        title: Text('BLUE'),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
              },
              icon: Icon(Icons.person),
              label: Text('logout'))
        ],
      ),
      body: Column(
        children: <Widget>[
          Text('total worldwide score'),
          Text(''),
          Text('blue button tapped'),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  DatabaseService().updateUserData();
                },
                child: Text('blue'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
