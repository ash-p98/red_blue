import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  String uid;

  DatabaseService({this.uid}) {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  // create user data required for the game (their name and score)
  final databaseReference = FirebaseDatabase.instance.reference();

  Future createUserData() async {
    print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        print("updated");
        return await databaseReference.child(uid).update({
          'value': 0,
        });
      }
      return await databaseReference.child(uid).update({
        'value': value.snapshot.value["value"] + 1,
      });
    });
  }

  void updateUserData() async {
    print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        print("updated");
        return await databaseReference.child(uid).update({
          'value': 0,
        });
      }
      return await databaseReference.child(uid).update({
        'value': value.snapshot.value["value"] + 1,
      });
    });
  }

  void decreaseUserData() async {
    print("updated" + uid.toString());
    return await databaseReference.child(uid).onValue.first.then((value) async {
      print(value.snapshot.value);
      if (value?.snapshot?.value == null ?? true) {
        print("updated");
        return await databaseReference.child(uid).update({
          'value': 0,
        });
      }
      return await databaseReference.child(uid).update({
        'value': value.snapshot.value["value"] - 1,
      });
    });
  }

  void readData() async {
    return await databaseReference.child(uid).once().then((value) async{
      print('${value.value}');
    });
  }
}

