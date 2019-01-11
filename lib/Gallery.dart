/*
Name: Akshath Jain
Date: 1/10/18
Purpose: display a list of ids
*/

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'Colors.dart';

class Gallery extends StatefulWidget{
  List ids; 
  Gallery({Key key, this.ids}) : super(key: key);

  @override
  _GalleryState createState() => new _GalleryState();
}

class _GalleryState extends State<Gallery>{
  PageController _controller;

  @override
  void initState() {
    _controller = new PageController();
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return 
    Container(
      color: Colors.grey.shade200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          //swiping view
          PageView.builder(
            itemCount: widget.ids.length,
            controller: _controller,
            itemBuilder: (context, i){
              return _ComplexNetworkImage(
                id: widget.ids[i],
              );
            },
          ),


          //dot indicators
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: PageIndicator(
              layout: PageIndicatorLayout.WARM,
              size: 8.0,
              controller: _controller,
              space: 5.0,
              count: widget.ids.length,
              color: Color.fromARGB(140, 255, 255, 255),
              activeColor: ACCENT_COLOR,
            )
          ),
        ]
      )
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_info == null)
      return Center(child: CircularProgressIndicator());

    if(_info["source_url"] == null)
      return Center(child: Text("Unable to access image"));

    return CachedNetworkImage(
      imageUrl: _info["source_url"],
      fit: _getImageFit(),
    );
  }

  BoxFit _getImageFit(){
    //case doesn't contain proper keys
    if(!_info.containsKey("media_details") || !_info["media_details"].containsKey("height") || !_info["media_details"].containsKey("width"))
      return BoxFit.cover;

    //width > height (landscape)
    if(_info["media_details"]["width"] > _info["media_details"]["height"])
      return BoxFit.cover;
    
    //height > width (portrait)
    return BoxFit.fitHeight;
  }

  Future<Map> fetchImageInfo() async {
    final response = await http.get("https://nashuproar.org/wp-json/wp/v2/media/" + widget.id);
    return json.decode(response.body);
  }
}