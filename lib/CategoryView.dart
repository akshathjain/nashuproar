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

  @override
  void initState() {
      _fetchCategoryInformation();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.categoryID),
    );
  }

  Future<Map> _fetchCategoryInformation() async {
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/categories/" + widget.categoryID);
    return json.decode(response.body);
  }

  Future<List> _fetchPosts() async {
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/posts?categories=" + widget.categoryID);
    return json.decode(response.body);
  }
}