import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:red_blue/services/ad_helper.dart';
import 'package:red_blue/services/database.dart';
import 'package:red_blue/shared/animations/wave.dart';
import 'package:spring_button/spring_button.dart';

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  int _myScore = 0;
  int _totalScore = 0;
  int _blue = 0;
  int _red = 0;
  StreamSubscription<Event> scoreListener;
  int _totalUsers = 0;
  int _globalBlue = 0;
  int _globalRed = 0;
  int _totalBlueTeamMembers = 0;
  int _totalRedTeamMembers = 0;
  BannerAd _ad;
  bool isLoaded;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.blueAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(
            () {
              isLoaded = true;
            },
          );
        },
        onAdFailedToLoad: (_, error) {
          print('Ad Failed to Load with Error: $error');
        },
      ),
    );
    _ad.load();
    scoreListener = DatabaseService().getScore(
        (myScore, totalScore, blue, red, userTotal, globalBlue, globalRed, totalBlueTeamMembers,
            totalRedTeamMembers) {
      if (mounted)
        setState(() {
          _myScore = myScore;
          _totalScore = totalScore;
          _blue = blue;
          _red = red;
          _globalBlue = globalBlue;
          _globalRed = globalRed;
          _totalBlueTeamMembers = totalBlueTeamMembers;
          _totalRedTeamMembers = totalRedTeamMembers;
        });
    });
    DatabaseService().getOnlineUsers((totalOnlineUser) {
      setState(() {
        _totalUsers = totalOnlineUser;
      });
    });
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
    scoreListener?.cancel();
    print("blue stopped");
  }

  Widget checkForAd() {
    if (isLoaded = true) {
      return Container(
        child: AdWidget(
          ad: _ad,
        ),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blue Team',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.blueAccent[400],
        elevation: 0.0,
      ),
      bottomNavigationBar: checkForAd(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueAccent[400], Colors.black],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Users Online ',
                            style: TextStyle(
                                color: Colors.lightGreenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                          WidgetSpan(
                            child: Icon(Icons.person,
                                size: 16, color: Colors.lightGreenAccent),
                          ),
                          TextSpan(
                            text: ' $_totalUsers',
                            style: TextStyle(
                                color: Colors.lightGreenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Users (Blue Team)',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                          WidgetSpan(
                            child: Icon(Icons.person,
                                size: 16, color: Colors.blue),
                          ),
                          TextSpan(
                            text: ' $_totalBlueTeamMembers',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Users (Red Team) ',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                          WidgetSpan(
                            child:
                            Icon(Icons.person, size: 16, color: Colors.red),
                          ),
                          TextSpan(
                            text: ' $_totalRedTeamMembers',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Nice choice, +1,000,000 is the goal.",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Divider(thickness: 2, color: Colors.lightBlueAccent[400]),
                  Text(
                    'Worldwide score:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: (_totalScore == 0
                        ? Text(
                            'No one is winning...',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontStyle: FontStyle.italic),
                          )
                        : _totalScore > 0
                            ? Text(
                                'Winning... again',
                                style: TextStyle(
                                    color: Colors.lightBlueAccent[400],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic),
                              )
                            : Text(
                                'You know what to do. Bring it back.',
                                style: TextStyle(
                                    color: Color(0xffff0000),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic),
                              )),
                  ),
                  Align(
                    child: Text(
                      '$_totalScore',
                      style: TextStyle(
                          color: (_totalScore == 0
                              ? Colors.white
                              : _totalScore > 0
                                  ? Colors.lightBlueAccent[400]
                                  : Color(0xffff0000)),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.lightBlueAccent),
                  Text(
                    'Team Taps:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '$_globalBlue',
                        style: TextStyle(
                            color: Colors.lightBlueAccent[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '$_globalRed',
                        style: TextStyle(
                            color: Color(0xffff0000),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Divider(thickness: 2, color: Colors.lightBlueAccent[400]),
                  Text(
                    'Your contribution:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Align(
                    child: (_myScore == 0
                        ? Text(
                      "Just choose a team...",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),
                    )
                        : _myScore > 0
                        ? Text("Blue is better. Just is.",
                      style: TextStyle(
                          color: Colors.lightBlueAccent[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),)
                        : Text("Become Blue.",
                      style: TextStyle(
                          color: Color(0xffff0000),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),)),
                  ),
                  Align(
                    child: Text(
                      '$_myScore',
                      style: TextStyle(
                          color: (_myScore == 0
                              ? Colors.white
                              : _myScore > 0
                                  ? Colors.lightBlueAccent[400]
                                  : Color(0xffff0000)),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.lightBlueAccent[400]),
                  Text(
                    'Your Total Taps:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '$_blue',
                        style: TextStyle(
                            color: (_blue > 0 ? Colors.lightBlueAccent[400] : Colors.white),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '$_red',
                        style: TextStyle(
                            color: (_red < 0 ? Color(0xffff0000) : Colors.white),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Divider(thickness: 2, color: Colors.lightBlueAccent[400]),
                  SpringButton(
                    SpringButtonType.OnlyScale,
                    Container(
                      padding: EdgeInsets.all(80),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.blueAccent,
                            ]),
                      ),
                      child: Align(
                        child: Text(
                          'Blue',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    onTapDown: (_) {
                      DatabaseService().updateUserData();
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 20, speed: 1),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 20, speed: 0.8, offset: pi),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 20, speed: 1.4, offset: pi / 2),
          ),
        ],
      ),
    );
  }
}
