/*
Name: Akshath Jain
Date: 1/7/18
Purpose: category view to display news stories, generic class
*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PostListView.dart';

class CategoryView extends StatefulWidget{
  final String categoryID;
  
  CategoryView({Key key, this.categoryID}) : super(key: key);

  @override
  _CategoryViewState createState() => new _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> with AutomaticKeepAliveClientMixin{
  int _totalCount;
  int _fetchedCount = 0;
  int _currentPage = 1;
  int _perpage = 25;
  List _posts;  

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
      super.initState();

      _fetchCategoryInformation().then((Map m){
        setSafeState(() {
          _totalCount = m["count"];
        });
      });

      _posts = new List();
      _getPosts();
  }

  //ensures no memory leaks, ensures that setstate not called after view is disposed
  void setSafeState(Function fn){
    if(mounted)
      setState(fn);
  } 

  @override
  Widget build(BuildContext context) {
    super.build(context);
   
    return PostListView(
      posts: _posts,
      enlargeFirstPost: true,
      canGetMorePosts: () => _fetchedCount < _totalCount,
      onGetMorePosts: _getPosts,
    );
  }

  void _getPosts(){
    _fetchPosts().then((List l){
      setSafeState((){
        _fetchedCount += l.length;
        _posts.addAll(l);
      });
    });
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