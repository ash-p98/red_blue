import 'package:firebase_database/firebase_database.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});


  // create user data required for the game (their name and score)
  final databaseReference = FirebaseDatabase.instance.reference();

  Future createUserData() async {
    return await databaseReference.child(uid).set({
      'value': 0,
    });
  }

  void updateUserData() async {
    return await databaseReference.child(uid).update({
      'value': ,
    });
  }

}