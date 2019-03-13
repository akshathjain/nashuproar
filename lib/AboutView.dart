/*
Name: Akshath Jain
Date: 1/13/18
Purpose: page that displays information about the app, developer, and open source licenses
*/

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Colors.dart';


class AboutView extends StatefulWidget{
  AboutView({Key key}) : super(key: key);

  @override
  _AboutViewState createState() => new _AboutViewState();
}

class _AboutViewState extends State<StatefulWidget>{
  String _version = "";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo pi){
      if(mounted){
        setState(() {
          _version = pi.version;
        });
      }
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
          
          
          //about the developer
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
          
          
          //open source licenses
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  _cardTitle("Open Source Licenses"),


                  _link("cached_network_image", "https://github.com/renefloor/flutter_cached_network_image/blob/master/LICENSE.md"),
                  _link("flutter_page_indicator", "https://github.com/best-flutter/flutter_page_indicator/blob/master/LICENSE"),
                  _link("html", "https://github.com/dart-lang/html/blob/master/LICENSE"),
                  _link("http", "https://github.com/dart-lang/http/blob/master/LICENSE"),
                  _link("package_info", "https://github.com/flutter/plugins/blob/master/packages/package_info/LICENSE"),
                  _link("share", "https://github.com/flutter/plugins/blob/master/packages/share/LICENSE"),
                  _link("shared_preferences", "https://github.com/flutter/plugins/blob/master/packages/shared_preferences/LICENSE"),
                  _link("url_launcher", "https://github.com/flutter/plugins/blob/master/packages/url_launcher/LICENSE"),


                  RaisedButton(
                    color: ACCENT_COLOR,
                    child: Text("View All"),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                      return new LicensePage();
                    })),
                  ),
                ],
              ),
            ),
          ),
          
          
          SizedBox(height: 24.0,), //padding
          
          
          //copyright
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
      padding: const EdgeInsets.only(bottom: 8.0, top: 2.0),
      child: Text(
        text, 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      )
    );
  }

  Widget _link(String cover, String url){
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () => _launchLink(url),
        child: Text(
          cover,
          style: TextStyle(
            color: ACCENT_COLOR,
            decoration: TextDecoration.underline,
          ),
        ),
      )
    );
  }

  void _launchLink(String url) async{
    if(await canLaunch(url))
      await launch(url);
  }
}