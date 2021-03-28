import 'dart:math';

import 'package:flutter/material.dart';
import 'package:red_blue/services/auth.dart';
import 'package:red_blue/shared/animations/wave.dart';
import 'package:red_blue/shared/constants.dart';
import 'package:red_blue/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.black87,
              elevation: 0.0,
              title: Text('Welcome'),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black87, Colors.deepPurpleAccent],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Please enter your email & password to login',
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Email'),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {
                                  setState(() => email = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password'),
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ characters long'
                                    : null,
                                obscureText: true,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepPurpleAccent),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    if (result == null) {
                                      setState(() {
                                        error = 'Email or Password incorrect';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red[200], fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 3, color: Colors.white),
                        SizedBox(height: 25),
                        Text(
                          'Register yourself to play',
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        OutlinedButton(
                          onPressed: widget.toggleView,
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
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
                  child: AnimatedWave(height: 120, speed: 0.8, offset: pi),
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
