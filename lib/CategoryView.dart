/*
Name: Akshath Jain
Date: 1/7/18
Purpose: category view to display news stories, generic class
*/

import 'package:flutter/material.dart';
import 'ArticleView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryView extends StatefulWidget{
  final String categoryID;
  
  CategoryView({Key key, this.categoryID}) : super(key: key);

  @override
  _CategoryViewState createState() => new _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>{
  int _totalCount;
  int _fetchedCount;
  int _currentPage = 1;
  int _perpage = 25;
  List _posts;  

  @override
  void initState() {
      super.initState();

      _fetchCategoryInformation().then((Map m){
        setSafeState(() {
            _totalCount = m["count"];
        });
      });

      _posts = new List();
      _fetchPosts().then((List l){
        setSafeState(() {
            _posts.addAll(l);    
        });
      });
  }

  void setSafeState(Function fn){
    if(mounted)
      setState(fn);
  } 

  @override
  Widget build(BuildContext context) {
    //case: still fetching posts
    if(_posts == null || _posts.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: Text(_posts.toString()),
    );
  }

  Future<Map> _fetchCategoryInformation() async {
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/categories/" + widget.categoryID);
    return json.decode(response.body);
  }

  Future<List> _fetchPosts() async {
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/posts?per_page=" + _perpage.toString() + "&page=" + _currentPage.toString() + "&_embed&categories=" + widget.categoryID);
    _currentPage++;
    return json.decode(response.body);
  }
}