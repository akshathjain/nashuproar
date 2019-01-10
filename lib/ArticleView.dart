/*
Name: Akshath Jain
Date: 1/8/18
Purpose: view an individual post/article
*/

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'Utils.dart';

class ArticleView extends StatefulWidget{
  final String id;
  
  ArticleView({Key key, this.id}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{
  Map _info; //the info about the articlew
  bool _hasGallery = false;
  List _galleryIds;

  @override
  void initState() {
    super.initState();
    fetchArticleInfo().then((Map m){
      setState(() {
        _info = m;

        //determines if article has a gallery
        _determineHasGallery();
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Back"),
            forceElevated: true,
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => Share.share(_info == null ? "" : _info["link"]),
                splashColor: Colors.black26,
                highlightColor: Colors.black12,
              ),
              IconButton(
                icon: Icon(Icons.open_in_browser),
                onPressed: () => _launchLink(_info == null ? "" : _info["link"]),
                splashColor: Colors.black26,
                highlightColor: Colors.black12,
              ),
            ],
          ),
          _createBody(),
        ],
      ),
    );
  }

  //the retracting toolbar requires sliver list => requires that body is List<Widget>
  //therefore, need to do some strange return processing stuff
  Widget _createBody(){
    //Case: the information still needs to be loaded
    if(_info == null){
      return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);
    }
    
    double pads = 20.0;

    //Case: the information has already loaded
    return SliverList(
      delegate: SliverChildListDelegate([
        _hasGallery ? _getGallery() : _getFeaturedImage(),
        Padding(
          padding: EdgeInsets.fromLTRB(pads, 16.0, pads, 6.0),
          child:  Html(
            data: _info["title"]["rendered"],
            defaultTextStyle: titleLargeStyle,
          ), //title
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(pads, 0.0, pads, 2.0),
          child: Text(
            _info["_embedded"]["author"][0]["name"],
            style: authorStyle,
          ), //author
        ),
        Padding(
          padding: EdgeInsets.only(left: pads, right: pads, bottom: 20.0),
          child: Text(
            getDate(DateTime.parse(_info["date"])), //date
            style: dateStyle,
          ),
        ),
        Html(
          padding: EdgeInsets.only(left: pads, right: pads),
          data: _info["content"]["rendered"],
          defaultTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 15.0
          ),
          onLinkTap: (url) => _launchLink(url),
          customRender: (node, children){
            if (node is dom.Element) {
              switch (node.localName) {
                case "iframe":
                  return _iframe(node);
                  break;
                case "script":
                  //_parseScriptForGalleryInfo(node.innerHtml);
                  break;
              }
            }
          },
        ), //article content
      ]),
    );
  }

  Widget _getFeaturedImage(){
    try{
      return AspectRatio(
        aspectRatio: 16.0/10.0,
        child: CachedNetworkImage(
          imageUrl: _info["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"],
          fit: BoxFit.cover,
        )
      );
    }catch(NoSuchMethodError){
      return Text("");
    }
  }

  Widget _iframe(var node){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ 
          Card(
            child: InkWell(
              onTap: () => _launchLink(node.attributes["src"]),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    height: 180.0,
                    imageUrl: "https://img.youtube.com/vi/" + node.attributes["src"].split("/")[node.attributes["src"].split("/").length - 1] + "/1.jpg",
                    fit: BoxFit.cover,
                  ),
                  Icon(Icons.play_circle_filled, color: Colors.white,),
                ],
              ),
            ),
          ),
        ]
      )
    );
  }
  
  void _determineHasGallery(){
    Html(
      data: _info["content"]["rendered"],
      customRender: (node, children){
        if(node is dom.Element){
          if(node.localName == "script"){
            List split = node.innerHtml.split(" ");
            _galleryIds = split[split.indexOf("photoids") + 2].toString().replaceAll("\'", "").replaceAll(";", "").split(","); //get the numbers
            _galleryIds.forEach((i) => i = int.tryParse(i)); //convert to int
            _hasGallery = true;
            return;
          }
        }
      },
    );
  }

  Widget _getGallery(){
    return Container();
  }

  void _launchLink(String url) async{
    if(await canLaunch(url))
      await launch(url);
  }

  Future<Map> fetchArticleInfo() async{
    final postInfo = await http.get("https://nashuproar.org/wp-json/wp/v2/posts/" + widget.id + "?_embed");
    return json.decode(postInfo.body);;
  }
}