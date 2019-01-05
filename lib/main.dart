import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(NASHUproar());

class NASHUproar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NASH Uproar',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        primaryColor: Colors.yellow.shade700,
        accentColor: Colors.black
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new ArticleView(
      url: "https://nashuproar.org/wp-json/wp/v2/posts/13407",
    );
  }
}

class ArticleView extends StatefulWidget{
  ArticleView({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{
  Map _info; //the info about the article

  @override
  void initState() {
    super.initState();
    print("hello");
    print(widget.url);
    fetchArticleInfo(widget.url).then((Map m){
      setState(() {
        print("hello");
        print(m);
        _info = m;
        print(m["title"]["rendered"]);
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: Text("NASH Uproar"),
      ),
      body: _createBody(),
    );
  }

  Widget _createBody(){
    //Case: the information still needs to be loaded
    if(_info == null){
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
    
    //Case: the information has already loaded
    return new ListView(
      children: <Widget>[
        Text(_info["title"]["rendered"]), //title
        Text(_getDate(DateTime.parse(_info["date"]))), //date
        Text("Author"), //author
        Text(_info["content"]["rendered"]), //article content
      ],
    );
  }

  String _getDate(DateTime dt){
    List months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[dt.month - 1] + " " + dt.day.toString() + ", " + dt.year.toString(); 
  }

  Future<Map> fetchArticleInfo(String url) async{
    final respone = await http.get(url);
    return json.decode(respone.body);
  }
}