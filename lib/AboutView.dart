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
  String _appName = "";
  String _version = "";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo pi){
      if(mounted){
        setState(() {
          _appName = pi.appName;
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
          
          //about the app
          Column( 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _appName,
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
          
          
          //About The Uproar
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _cardTitle("Mission Statement"),
                  Text("The Uproar is the product of the Journalism classes at North Allegheny Senior High School in Wexford, PA. Contributions from the NATV classes allow the site to deliver multimedia to our readership."),
                  
                  SizedBox(height: 12.0,),
                  
                  Text("Our aim is to represent the student voice of the school and to provide the student body, the school faculty and administration, and the families of our community with timely reporting, compelling opinions, and entertaining miscellany. We are dedicated to the highest standard of journalistic integrity and strive to enhance school culture through our work."),
                  
                  SizedBox(height: 12.0,),
                  
                  Text("Opinions expressed in by-lined editorials reflect the views of the author and not the entire staff or student body. The Uproar welcomes letters to the editor, so please let us know what you think. Send an email titled “Letter to the Editor” to nashuproar@gmail.com. No anonymous letters will be published."),
                  
                  SizedBox(height: 12.0,),
                  
                  Text("The Uproar intends for this area to be used to foster reasonable, thoughtful discussion. Comments are expected to adhere to our standards and to be respectful and constructive. We therefore do not permit the use of profanity, foul language, personal attacks, or language that could be interpreted as libelous. Comments are reviewed and must be approved by the faculty adviser to ensure that they meet these standards. The Uproar does not allow anonymous comments, and we require a valid email address. The email address will not be displayed but will be used to confirm your comments."),
                  
                  SizedBox(height: 12.0,),
                  
                  Text("All advertising inquiries should be directed to the program adviser, Mr. Morris, at dmorris@northallegheny.org."),
                ],
              ),
            ),
          ),


          SizedBox(height: 24.0,), //padding


          //about the developer
          Card( // about the dev
            child: InkWell(
              onTap: () => _launchLink("https://akshathjain.com"),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
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
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  _cardTitle("Open Source Licenses"),


                  _link("cached_network_image", "https://github.com/renefloor/flutter_cached_network_image/blob/master/LICENSE.md"),
                  _link("flutter_html", "https://github.com/Sub6Resources/flutter_html/blob/master/LICENSE"),
                  _link("flutter_page_indicator", "https://github.com/best-flutter/flutter_page_indicator/blob/master/LICENSE"),
                  _link("html", "https://github.com/dart-lang/html/blob/master/LICENSE"),
                  _link("http", "https://github.com/dart-lang/http/blob/master/LICENSE"),
                  _link("package_info", "https://github.com/flutter/plugins/blob/master/packages/package_info/LICENSE"),
                  _link("share", "https://github.com/flutter/plugins/blob/master/packages/share/LICENSE"),
                  _link("shared_preferences", "https://github.com/flutter/plugins/blob/master/packages/shared_preferences/LICENSE"),
                  _link("url_launcher", "https://github.com/flutter/plugins/blob/master/packages/url_launcher/LICENSE"),

                  SizedBox(height: 8.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        color: ACCENT_COLOR,
                        child: Text("View All"),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                          return new LicensePage();
                        })),
                      ),
                    ],
                  ),

                  
                ],
              ),
            ),
          ),
          
          
          SizedBox(height: 24.0,), //padding
          
          
          //copyright
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _cardTitle("Copyright"),
                  Text("© 2019" + (DateTime.now().year.toString() == "2019" ? "" : "-" + DateTime.now().year.toString()) + " Akshath Jain. All Rights Reserved"),
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