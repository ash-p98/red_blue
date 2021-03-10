import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_blue/models/user.dart';
import 'package:red_blue/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:red_blue/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<userInfo>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
