/*
Name: Akshath Jain
Date: 1/13/18
Purpose: page that displays information about the app, developer, and open source licenses
*/

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AboutView extends StatefulWidget{
  AboutView({Key key}) : super(key: key);

  @override
  _AboutViewState createState() => new _AboutViewState();
}

class _AboutViewState extends State<StatefulWidget>{
  String _version;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo pi){
      _version = pi.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 12.0),
        children: <Widget>[
          Column( //about the app
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "NASH Uproar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 4.0,),
              Text("Version: $_version"),
            ],
          ),
          SizedBox(height: 24.0,), //padding
          Card( // about the dev
            child: InkWell(
              onTap: () => _launchLink("https://akshathjain.com"),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _cardTitle("Developer"),
                    Text("Akshath Jain"),
                    Text("Designed and developed in Pittsburgh, PA"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24.0,), //padding
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _cardTitle("Open-Source Licenses"),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.0,), //padding
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _cardTitle("Copyright"),
                  Text("© " + DateTime.now().year.toString() + " Akshath Jain. All Rights Reserved"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardTitle(String text){
    return Container(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text, 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      )
    );
  }

  void _launchLink(String url) async{
    if(await canLaunch(url))
      await launch(url);
  }
}