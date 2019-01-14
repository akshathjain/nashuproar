/*
Name: Akshath Jain
Date: 1/8/18
Purpose: search view class for searching nash uproar
*/

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'PostListView.dart';

class SearchView extends StatefulWidget{
  SearchView({Key key}) : super(key: key);

  @override
  createState() => new _SearchView();
}

class _SearchView extends State<SearchView>{
  List _posts = new List();
  int _totalCount = 0;
  int _fetchedCount = 0;
  int _page = 1;
  int _perpage = 25;
  bool _noResults = false;
  String _searchTerm = "";
  TextEditingController _inputController = new TextEditingController(); //used to clear the search text
  FocusNode _inputFocus = new FocusNode(); //used to focus input when search cleared

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new TextField(
          controller: _inputController,
          focusNode: _inputFocus,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
          ),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
          onSubmitted: (String term){
            _page = 1;
            _searchTerm = term;
            _posts = new List();
            _noResults = false;
            _getPosts();
          }
        ),
        actions: <Widget>[
          _showClearSearch(),
        ],
      ),
      body: _createBody(),
    );
  }

  void _getPosts(){
    if(_searchTerm != null || _searchTerm != ""){
      fetchPosts().then((List data){
        if(mounted){
          setState((){            
            if(data != null && data.isNotEmpty){
              if(_posts != null)
                _posts.addAll(data);
              else
                _posts = data;

              _fetchedCount += data.length;
            }else{
              _noResults = true;
            }
          });
        }
      });
    }    
  }

  Widget _createBody(){
    if(_searchTerm == "")
      return Center(child: Text('Search for an article'),);

    if(_noResults)
      return Center(child: Text('No articles found',));

    if(_posts != null && _posts.isNotEmpty)
      return _createListView();
    else
      return Center(child: CircularProgressIndicator(),);    
  }

  Widget _createListView(){
    if(_posts == null)
      return new Container();
    else if(_posts.isEmpty)
      return new Center(child: Text('No articles found'),);

    return PostListView(
      posts: _posts,
      enlargeFirstPost: false,
      canGetMorePosts: () => _fetchedCount < _totalCount,
      onGetMorePosts: _getPosts,
    );
  }

  Widget _showClearSearch(){
    if(_searchTerm != ""){
      return new IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          _searchTerm = "";
          _inputController.clear();
          FocusScope.of(context).requestFocus(_inputFocus);
        },
      );
    }
    return Container();
  }

  //get the search stuff
  Future<List> fetchPosts() async{
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/posts?search=" + _searchTerm + "&page=" + _page.toString() + "&_embed&categories_exclude=92&per_page=" + _perpage.toString()); //exclude morning announcements from search
    _totalCount = int.tryParse(response.headers["x-wp-total"]); //get the total number of posts
    _page++;
    return json.decode(response.body);
  }
}