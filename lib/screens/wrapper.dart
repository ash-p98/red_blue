import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_blue/models/user.dart';
import 'package:red_blue/screens/authenticate/authenticate.dart';
import 'package:red_blue/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<userInfo>(context);

    //return either Home or Authenticate widget
    if (user == null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}
