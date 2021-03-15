import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:red_blue/services/database.dart';

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  int _myScore = 0;
  int _totalScore = 0;
  int _blue = 0;
  int _redWins = 0;
  int _blueWins = 0;
  StreamSubscription<Event> scoreListener;

  @override
  void initState() {
    super.initState();
    scoreListener =
        DatabaseService().getScore((myScore, totalScore, blue, red, userTotal) {
          if (mounted)
            setState(() {
              _myScore = myScore;
              _totalScore = totalScore;
              _blue = blue;
            });
        });
    DatabaseService().getWins((redWin, blueWin) {
      if (mounted)
        setState(() {
          _redWins = redWin;
          _blueWins = blueWin;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scoreListener?.cancel();
    print("blue stopped");
  }

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
              onPressed: () async {},
              icon: Icon(Icons.person),
              label: Text('logout'))
        ],
      ),
      body: Column(
        children: <Widget>[
          Text('total worldwide score = $_totalScore'),
          Text('you pressed blue this many: $_blue'),
          Text('your contribution = $_myScore'),
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
          Text('red wins: $_redWins'),
          Text('blue wins: $_blueWins'),
        ],
      ),
    );
  }
}
