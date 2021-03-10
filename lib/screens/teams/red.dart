import 'package:flutter/material.dart';

class Red extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      appBar: AppBar(
        title: Text('RED'),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
              },
              icon: Icon(Icons.person),
              label: Text('logout'))
        ],
      ),
      body: Column(
        children: <Widget>[
          Text('total worldwide score'),
          Text('your total score'),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: Text('red'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
