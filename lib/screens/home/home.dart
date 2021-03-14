import 'package:flutter/material.dart';
import 'package:red_blue/services/auth.dart';
import 'package:red_blue/screens/teams/blue.dart';
import 'package:red_blue/screens/teams/red.dart';
import 'package:red_blue/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _myScore = 0;
  int _totalScore = 0;
  int _red = 0;
  int _blue = 0;
  int _userTotal = 0;

  @override
  void initState() {
    super.initState();
    DatabaseService().getScore((myScore, totalScore, blue, red, userTotal) {
      setState(() {
        _myScore = myScore;
        _totalScore = totalScore;
        _red = red;
        _blue = blue;
        _userTotal = userTotal;
      });
    });
  }

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
          Text('total worldwide score: $_totalScore'),
          Text('your contribution: $_myScore'),
          Row(
            children: <Widget>[
              Text('blue taps: $_blue'),
              Text('red taps: :$_red'),
            ],
          ),
          Text('your total taps: $_userTotal'),
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