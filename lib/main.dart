/*
Name: Akshath Jain
Date: 1/7/18
Purpose: NASH Uproar Android/iOS application
*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CategoryView.dart';
import 'SearchView.dart';
import 'Colors.dart';

void main() => runApp(NASHUproar());

class NASHUproar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NASH Uproar',
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR,
        primaryColorLight: PRIMARY_COLOR_LIGHT,
        primaryColorDark: PRIMARY_COLOR_DARK,
        accentColor: ACCENT_COLOR,
        brightness: Brightness.light
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  List _categories;
  TabController _tabController;

  @override
  void initState() {
    _tabController = _createTabController();

    _fetchCategories().then((List l){
      setState(() {
        _categories = l;
        _tabController = _createTabController();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NASH Uproar"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            splashColor: Colors.black26,
            highlightColor: Colors.black12,
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new SearchView()
              ));
            },
          ),
        ],
        bottom: TabBar(
          isScrollable: true,
          tabs: _createTabs(),
          controller: _tabController,
        ),
      ),
      body: _createBody(),
    );
  }

  List<Tab> _createTabs(){
    if(_categories == null) //categories hasn't been initialized yet
      return [];

    //create list of tabs
    List<Tab> tabs = new List();
    for(int i = 0; i < _categories.length; i++){
      tabs.add(new Tab(
        text: _categories[i]["name"],
      ));
    }
    return tabs;
  }

  //need to make a custom tab controller b/c default doesn't support variable lengths
  TabController _createTabController(){
    return TabController(
      vsync: this,
      length: _categories == null ? 0 : _categories.length,
      initialIndex: _categories == null ? 0 : _categories.indexWhere((category) => category["is-home"] == true), //set this based on index of homepage in _categories
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
    List<Widget> pages = new List();
    for(int i = 0; i < _categories.length; i++){
      pages.add(new CategoryView(
        categoryID: _categories[i]["categoryID"],
      ));
    }
    
    return TabBarView(
      children: pages,
      controller: _tabController,
    );
  }

  Future<List> _fetchCategories() async{
    final response = await http.get("https://akshathjain.com/nashuproar/categories.json");
    return json.decode(response.body);
  }
}