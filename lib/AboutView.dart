/*
Name: Akshath Jain
Date: 1/13/18
Purpose: page that displays information about the app, developer, and open source licenses
*/

import 'package:flutter/material.dart';

class AboutView extends StatefulWidget{
  AboutView({Key key}) : super(key: key);

  @override
  _AboutViewState createState() => new _AboutViewState();
}

class _AboutViewState extends State<StatefulWidget>{

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
    );
  }
}