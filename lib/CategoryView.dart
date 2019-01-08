/*
Name: Akshath Jain
Date: 1/7/18
Purpose: category view to display news stories, generic class
*/

import 'package:flutter/material.dart';
import 'ArticleView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryView extends StatefulWidget{
  final String categoryID;
  
  CategoryView({Key key, this.categoryID}) : super(key: key);

  @override
  _CategoryViewState createState() => new _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> with AutomaticKeepAliveClientMixin{
  int _totalCount;
  int _fetchedCount;
  int _currentPage = 1;
  int _perpage = 25;
  List _posts;  

  @override
  bool get wantKeepAlive => false;

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

  //ensures no memory leaks, ensures that setstate not called after view is disposed
  void setSafeState(Function fn){
    if(mounted)
      setState(fn);
  } 

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //case: still fetching posts
    if(_posts == null || _posts.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (BuildContext context, int i){
        return Card(
          child: InkWell(
            onTap: () => _openPost(context, i),
            child: Row(
              children: <Widget>[
                _getFeaturedImage(i),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ConstrainedBox(
                      child: Html(
                        data: _posts[i]["title"]["rendered"],
                      ),
                      constraints: const BoxConstraints(maxWidth: 275.0),
                    ),
                    Text(getDate(DateTime.parse(_posts[i]["date"]))),
                  ],
                ),
              ],
            )
          ),
        );
      },
    );
  }

  Widget _getFeaturedImage(int index){
    try{
      return CachedNetworkImage(
          imageUrl: _posts[index]["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
      );
    }catch(NoSuchMethodError){
      return Text("");
    }
  }

  void _openPost(BuildContext context, int index){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new ArticleView(
            id: _posts[index]["id"].toString(),
          );
        }
      ),
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