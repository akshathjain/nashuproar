/*
Name: Akshath Jain
Date: 1/10/18
Purpose: display a list of ids
*/

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Gallery extends StatefulWidget{
  List ids; 
  Gallery({Key key, this.ids}) : super(key: key);

  @override
  _GalleryState createState() => new _GalleryState();
}

class _GalleryState extends State<Gallery>{
  
  @override Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.ids.length,
      itemBuilder: (context, i){
        return _ComplexNetworkImage(
          id: widget.ids[i],
        );
      },
    );
  }
}


//widget that handles data retrieval for each widget
class _ComplexNetworkImage extends StatefulWidget{
  final String id;

  _ComplexNetworkImage({Key key, this.id}) : super(key: key);

  @override
  _ComplexNetworkImageState createState() => new _ComplexNetworkImageState();
}

class _ComplexNetworkImageState extends State<_ComplexNetworkImage> with AutomaticKeepAliveClientMixin{
  Map _info;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    fetchImageInfo().then((Map m){
      if(mounted){
        setState(() {
          this._info = m;
          print(widget.id);
          print(_info);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_info == null)
      return Center(child: CircularProgressIndicator());

    return CachedNetworkImage(
      imageUrl: _info["source_url"],
      fit: BoxFit.cover,
    );
  }

  Future<Map> fetchImageInfo() async {
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/media/" + widget.id);
    return json.decode(response.body);
  }
}