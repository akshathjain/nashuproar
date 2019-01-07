import 'package:flutter/material.dart';
import 'ArticleView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List _categories;

  @override
  void initState() {     
    _fetchCategories().then((List l){
      setState(() {
        _categories = l;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories == null ? 0 : _categories.length,
      initialIndex: _categories == null ? 0 : _categories.indexWhere((category) => category["is-home"] == true), //set this based on index of homepage in _categories
      child: Scaffold(
        appBar: AppBar(
          title: Text("NASH Uproar"),
          bottom: _createTabBar(),
        ),
        body: _createBody(),
      ),
    );
  }

  TabBar _createTabBar(){
    //only create if the data has been loaded, otherwise return null

    //create a list of tabs
    List<Tab> tabs = new List();
    for(int i = 0; i < _categories.length; i++){
      tabs.add(new Tab(
        text: _categories[i]["name"],
      ));
    }

    return TabBar(
      isScrollable: true,
      tabs: tabs,
    );
  }

  Widget _createBody(){
    //case 1: data hasn't loaded yet
    if(_categories == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //case 2: the data has already loaded, create the tabbar view
    
  }

  Future<List> _fetchCategories() async{
    final response = await http.get("https://raw.githubusercontent.com/akshathjain/nashuproar/master/categories.json");
    return json.decode(response.body);
  }
}