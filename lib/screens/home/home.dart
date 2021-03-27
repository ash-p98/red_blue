import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:red_blue/screens/settings.dart';
import 'package:red_blue/screens/teams/blue.dart';
import 'package:red_blue/screens/teams/red.dart';
import 'package:red_blue/services/database.dart';
import 'package:red_blue/shared/animations/wave.dart';
import 'package:spring_button/spring_button.dart';
import 'package:red_blue/services/ad_helper.dart';

import '../../services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int _myScore = 0;
  int _totalScore = 0;
  StreamSubscription<Event> scoreListener;
  int _totalUsers = 0;
  int _redWins = 0;
  int _blueWins = 0;
  int _globalBlue = 0;
  int _globalRed = 0;
  BannerAd _ad;
  bool isLoaded;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
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
    WidgetsBinding.instance.addObserver(this);
    scoreListener = DatabaseService().getHomeScore(
      (myScore, totalScore, blue, red, userTotal, globalBlue, globalRed) {
        if (mounted)
          setState(
            () {
              _myScore = myScore;
              _totalScore = totalScore;
              _globalBlue = globalBlue;
              _globalRed = globalRed;
            },
          );
      },
    );
    DatabaseService().getOnlineUsers(
      (totalOnlineUser) {
        setState(
          () {
            _totalUsers = totalOnlineUser;
          },
        );
      },
    );
    DatabaseService().getWins(
      (redWin, blueWin) {
        if (mounted)
          setState(
            () {
              _redWins = redWin;
              _blueWins = blueWin;
            },
          );
      },
    );
    DatabaseService().updateOnlineStatus(true);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await DatabaseService().updateOnlineStatus(false);
    scoreListener?.cancel();
    _ad?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed)
      await DatabaseService().updateOnlineStatus(true);
    else
      await DatabaseService().updateOnlineStatus(false);

    print('state = $state');
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
          'R v B: TUG of WAR',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: Text(''),
          ),
        ],
      ),
      bottomNavigationBar: checkForAd(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.deepPurpleAccent[400]],
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
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
                  // Text(
                  //   'WORLDWIDE TUG OF WAR!',
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       // fontWeight: FontWeight.bold,
                  //       fontSize: 24,
                  //       fontStyle: FontStyle.italic,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Blue team wins if Worldwide Score is +1,000,000',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.lightBlueAccent[400],
                              // fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Red team wins if Worldwide Score is -1,000,000',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color(0xffff3421),
                              // fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Divider(thickness: 2, color: Colors.deepPurpleAccent),
                  // Text(
                  //   'Team Wins:',
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //       fontStyle: FontStyle.italic),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: <Widget>[
                  //     Text(
                  //       '$_blueWins',
                  //       style: TextStyle(
                  //           color: Colors.lightBlueAccent,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 30,
                  //           fontStyle: FontStyle.italic),
                  //     ),
                  //     Text(
                  //       '-',
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 30,
                  //           fontStyle: FontStyle.italic),
                  //     ),
                  //     Text(
                  //       '$_redWins',
                  //       style: TextStyle(
                  //           color: Colors.redAccent,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 30,
                  //           fontStyle: FontStyle.italic),
                  //     ),
                  //   ],
                  // ),
                  Divider(thickness: 2, color: Colors.deepPurpleAccent),
                  Text(
                    'Worldwide Score:',
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
                        ? Text('Blue Team is in the lead!',
                      style: TextStyle(
                          color: Colors.lightBlueAccent[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),)
                        : Text('Red Team is in the lead!',
                      style: TextStyle(
                          color: Color(0xffff3421),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),)),
                  ),
                  Align(
                    child: Text(
                      '$_totalScore',
                      style: TextStyle(
                          color: (_totalScore == 0
                              ? Colors.white
                              : _totalScore > 0
                                  ? Colors.lightBlueAccent[400]
                                  : Color(0xffff3421)),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.deepPurpleAccent),
                  Text(
                    'Total Worldwide Taps:',
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
                            color: Color(0xffff3421),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Divider(thickness: 2, color: Colors.deepPurpleAccent),
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
                            ? Text("You're Blue Team!",
                      style: TextStyle(
                          color: Colors.lightBlueAccent[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),)
                            : Text("You're Red Team!",
                      style: TextStyle(
                          color: Color(0xffff3421),
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
                                  : Color(0xffff3421)),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.deepPurpleAccent),
                  Text(
                    'Team Selection:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SpringButton(
                        SpringButtonType.OnlyScale,
                        Container(
                          padding: EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.lightBlueAccent[400],
                                  Colors.blueAccent[400],
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Blue()),
                          );
                        },
                      ),
                      SpringButton(
                        SpringButtonType.OnlyScale,
                        Container(
                          padding: EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Color(0xffff3421),
                                  Colors.redAccent[400],
                                ]),
                          ),
                          child: Align(
                            child: Text(
                              'Red',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        onTapDown: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Red()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 20, speed: 1),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: AnimatedWave(height: 20, speed: 1.8, offset: pi),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: 20, speed: 1.4, offset: pi / 2),
          ),
        ],
      ),
    );
  }
}
