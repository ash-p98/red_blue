import 'package:flutter/material.dart';
import 'package:red_blue/services/auth.dart';
import 'package:red_blue/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:red_blue/screens/teams/blue.dart';
import 'package:red_blue/screens/teams/red.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: AppBar(
        title: Text('pick ya team!'),
        backgroundColor: Colors.deepPurpleAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('logout'))
        ],
      ),
      body: Column(
        children: <Widget>[
          Text('total worldwide score'),
          Text('your total score'),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Blue()),
                  );
                },
                child: Text('blue'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Red()),
                  );
                },
                child: Text('red'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
