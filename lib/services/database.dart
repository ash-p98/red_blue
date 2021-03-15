import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  String uid;
  final WINNING_POINT_LIMIT = 20;

  DatabaseService({this.uid}) {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  // create user data required for the game (their name and score)
  final databaseReference =
  FirebaseDatabase.instance.reference().child("users");
  final databaseReferenceOnlineUsers =
  FirebaseDatabase.instance.reference().child("online_user");

  final databaseScore = FirebaseDatabase.instance.reference().child("score");

  //create user personal scoring system
  Future createUserData() async {
    // print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      // print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        // print("updated");
        return await databaseReference.child(uid).update({
          'value': 0,
          'blue': 0,
          'red': 0,
        });
      }
      return await databaseReference.child(uid).update({
        'value': value.snapshot.value["value"] + 1,
      });
    });
  }

  // increase the score
  void updateUserData() async {
    //print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      //print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        //print("updated");
        return await databaseReference.child(uid).update({
          'value': 0,
          'blue': 0,
        });
      }
      return await databaseReference.child(uid).update({
        'value': value.snapshot.value["value"] + 1,
        'blue': value.snapshot.value["blue"] + 1,
      });
    });
  }

  //decrease user score
  void decreaseUserData() async {
    //print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      //print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        //print("updated");
        return await databaseReference.child(uid).update({
          'value': 0,
          'red': 0,
        });
      }
      return await databaseReference.child(uid).update({
        'value': value.snapshot.value["value"] - 1,
        'red': value.snapshot.value["red"] - 1,
      });
    });
  }

  //show the score on front end
  StreamSubscription<Event> getScore(
      Function(int myScore, int totalScore, int blue, int red, int userTotal)
      data) {
    var subscription = databaseReference.onValue.listen((event) async {
      Map<dynamic, dynamic> users = event.snapshot.value;
      Map<String, dynamic> updatedUsers = Map<String, dynamic>();

      int totalScore = 0;
      int userScore = 0;
      int blue = 0;
      int red = 0;
      int userTotal = 0;
      users.forEach((key, value) {
        totalScore += value["value"];
        if (key == uid) {
          userScore = value["value"];
          blue = value["blue"];
          red = value["red"];
          userTotal += (value["red"] * -1) + value["blue"];
        }
        value["value"] = 0;
        updatedUsers.putIfAbsent(key, () => value);
      });

      if (totalScore >= WINNING_POINT_LIMIT ||
          totalScore <= -WINNING_POINT_LIMIT) {
        var totalStatus = await databaseScore.onValue.first;
        print("setting score");
        Map<dynamic, dynamic> score = totalStatus.snapshot.value;
        int redWin = score == null ? 0 : score["redWins"];
        int blueWin = score == null ? 0 : score["blueWins"];
        if (totalScore >= WINNING_POINT_LIMIT)
          blueWin++;
        else
          redWin++;
        await databaseReference.update(updatedUsers);
        await databaseScore.update({
          'blueWins': blueWin,
          'redWins': redWin,
        });
      }
      data.call(userScore, totalScore, blue, red, userTotal);
    });
    return subscription;
  }

  StreamSubscription<Event> getHomeScore(
      Function(int myScore, int totalScore, int blue, int red, int userTotal)
      data) {
    var subscription = databaseReference.onValue.listen((event) async {
      Map<dynamic, dynamic> users = event.snapshot.value;
      Map<String, dynamic> updatedUsers = Map<String, dynamic>();
      int totalScore = 0;
      int userScore = 0;
      int blue = 0;
      int red = 0;
      int userTotal = 0;
      users.forEach((key, value) {
        totalScore += value["value"];
        if (key == uid) {
          userScore = value["value"];
          blue = value["blue"];
          red = value["red"];
          userTotal += (value["red"] * -1) + value["blue"];
        }
        value["value"] = 0;
        updatedUsers.putIfAbsent(key, () => value);
      });

      data.call(userScore, totalScore, blue, red, userTotal);
    });

    return subscription;
  }

  //show the wins on the front end

  void getWins(Function(int redWin, int blueWin) data) async {
    databaseScore.onValue.listen((event) {
      print(event);
      Map<dynamic, dynamic> score = event.snapshot.value;
      int totalRedWins = score == null ? 0 : score["redWins"];
      int totalBlueWins = score == null ? 0 : score["blueWins"];
      data.call(totalRedWins, totalBlueWins);
    });
  }

  void getOnlineUsers(Function(int totalOnlineUser) data) async {
    databaseReferenceOnlineUsers.onValue.listen((event) {
      if (event?.snapshot?.value == null ?? true) {
        data.call(0);
        return;
      }
      Map<dynamic, dynamic> mapData = event.snapshot.value;
      print("mapdate\n" + mapData.toString());
      print(mapData.length);
      data.call(mapData.length);
    });
  }

  Future updateOnlineStatus(bool isOnline) async {
    if (isOnline)
      await databaseReferenceOnlineUsers.child(uid).set(uid);
    else {
      await databaseReferenceOnlineUsers.child(uid).remove();
      print("deleted");
    }
  }
}
