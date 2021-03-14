import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  String uid;

  DatabaseService({this.uid}) {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  // create user data required for the game (their name and score)
  final databaseReference =
  FirebaseDatabase.instance.reference().child("users");

  final databaseScore =
  FirebaseDatabase.instance.reference().child("score");

  //create user personal scoring system
  Future createUserData() async {
    print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        print("updated");
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

  //create database wins scoring system
  Future createWins() async {
    return await databaseScore.child('wins').onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true){
        return await databaseScore.update({
          'blueWins': 0,
          'redWins': 0,
        });
      }
    });
  }

  // increase the score
  void updateUserData() async {
    print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        print("updated");
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

  //increase blue wins
  void increaseBlueWins() async {
    return await databaseScore.child('wins').onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true){
        return await databaseScore.update({
          'blueWins': 0,
          'redWins': 0,
        });
      }
      return await databaseScore.child('wins').update({
        'blueWins': value.snapshot.value["blueWins"] + 1,
      });
    });
  }

  //decrease user score
  void decreaseUserData() async {
    print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        print("updated");
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

  //increase red wins
  void increaseRedWins() async {
    return await databaseScore.child('wins').onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true){
        return await databaseScore.update({
          'blueWins': 0,
          'redWins': 0,
        });
      }
      return await databaseScore.child('wins').update({
        'redWins': value.snapshot.value["redWins"] + 1,
      });
    });
  }

  //show the score on front end
  void getScore(Function(int myScore, int totalScore, int blue, int red, int userTotal) data) async {
    databaseReference.onValue.listen((event) {
      Map<dynamic, dynamic> users = event.snapshot.value;
      int totalScore = 0;
      int userScore = 0;
      int blue = 0;
      int red = 0;
      int userTotal = 0;
      users.forEach((key, value) {
        totalScore += value["value"];
        if (key == uid){
          userScore = value["value"];
          blue = value["blue"];
          red = value["red"];
          userTotal += (value["red"]*-1)+value["blue"];
        }
      });
      data.call(userScore, totalScore, blue, red, userTotal);
    });
  }

  //show the wins on the front end
  void getWins(Function(int redWin, int blueWin) data) async {
    databaseScore.onValue.listen((event) {
      Map<dynamic, dynamic> score = event.snapshot.value;
      int redWin = 0;
      int blueWin = 0;
    });
  }

}

