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
import 'SettingsDialog.dart';
import 'Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NASHUproar());

class NASHUproar extends StatefulWidget {
  NASHUproar({Key key}) : super(key: key);

  @override
  _NASHUproarState createState() => new _NASHUproarState();
}

class _NASHUproarState extends State<NASHUproar>{
  Brightness _brightness = Brightness.light;

  @override
  void initState() {
    super.initState();

    _initSharedPrefs().then((SharedPreferences prefs){
      setState(() {
        int theme = prefs.getInt("theme-value");
        print(theme);
        if(theme == SettingsDialog.LIGHT_VALUE)
          _brightness = Brightness.light;
        else if(theme == SettingsDialog.DARK_VALUIE)
          _brightness = Brightness.dark;
      }); //rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NASH Uproar',
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR_DARK,
        primaryColorLight: PRIMARY_COLOR_DARK_LIGHTER,
        primaryColorDark: PRIMARY_COLOR_DARK_DARKER,
        accentColor: ACCENT_COLOR,
        brightness: _brightness,
      ),
      home: HomePage(),
    );
  }

  Future<SharedPreferences> _initSharedPrefs() async{
    return await SharedPreferences.getInstance();
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
            tooltip: "Search",
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new SearchView()
              ));
            },
          ),

          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "settings",
                child: Text("Settings"),
              ),
              const PopupMenuItem(
                value: "about",
                child: Text("About"),
              ),
            ],

            onSelected: (String choice){
              if(choice == "settings"){
                showDialog(
                  context: context, 
                  child: SettingsDialog()
                );
              }else if(choice == "about"){
                // Navigator.push(context, new MaterialPageRoute(
                //   builder: (context) => new SearchView()
                // ));
              }
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