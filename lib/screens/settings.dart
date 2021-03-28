import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:red_blue/screens/authenticate/sign_in.dart';
import 'package:red_blue/services/auth.dart';
import 'package:red_blue/services/database.dart';
import 'package:red_blue/shared/animations/wave.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  int _myScore = 0;
  int _totalScore = 0;
  int _red = 0;
  int _blue = 0;
  int _userTotal = 0;
  StreamSubscription<Event> scoreListener;
  int totalUsers = 0;
  int _globalBlue = 0;

  @override
  void initState() {
    super.initState();
    scoreListener =
        DatabaseService().getScore((myScore, totalScore, blue, red, userTotal, globalBlue, globalRed, totalBlueTeamMembers,totalRedTeamMembers) {
      if (mounted)
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
  void dispose() async {
    scoreListener?.cancel();
    super.dispose();
    print("settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stats / Settings',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurpleAccent, Colors.black],
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Here you can see your stats and adjust your settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  Divider(thickness: 2, color: Colors.black),
                  Text(
                    'Worldwide score:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: Text(
                      '$_totalScore',
                      style: TextStyle(
                          color: (_totalScore == 0
                              ? Colors.white
                              : _totalScore > 0
                                  ? Colors.lightBlueAccent
                                  : Colors.redAccent),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.black),
                  Text(
                    'Your contribution:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: Text(
                      '$_myScore',
                      style: TextStyle(
                          color: (_myScore == 0
                              ? Colors.white
                              : _myScore > 0
                                  ? Colors.lightBlueAccent
                                  : Colors.redAccent),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.black),
                  Text(
                    'Blue button pressed:',
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: Text(
                      '$_blue',
                      style: TextStyle(
                          color: (_blue > 0
                              ? Colors.lightBlueAccent
                              : Colors.white),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.black),
                  Text(
                    'Red button pressed:',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: Text(
                      '$_red',
                      style: TextStyle(
                          color: (_red < 0 ? Colors.red : Colors.white),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.black),
                  Text(
                    'Total button presses:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: Text(
                      '$_userTotal',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.black),
                  SizedBox(height: 50),
                  Align(
                    child: OutlinedButton(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          scoreListener?.cancel();
                          DatabaseService().updateOnlineStatus(false);
                          await _auth.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 180, speed: 1),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 150, speed: 0.8, offset: pi),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 220, speed: 1.4, offset: pi / 2),
          ),
        ],
      ),
    );
  }
}
