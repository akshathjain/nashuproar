import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Utils.dart';

class ArticleView extends StatefulWidget{
  final String id;
  
  ArticleView({Key key, this.id}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{
  Map _info; //the info about the articlew
  @override
  void initState() {
    super.initState();
    fetchArticleInfo().then((Map m){
      setState(() {
        _info = m;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Back"),
      ),
      body: _createBody(),
    );
  }

  Widget _createBody(){
    //Case: the information still needs to be loaded
    if(_info == null){
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
    
    double pads = 20.0;

    //Case: the information has already loaded
    return new ListView(
      children: <Widget>[
        _getFeaturedImage(),
        Padding(
          padding: EdgeInsets.only(left: pads, right: pads, top: 16.0),
          child:  Html(
            data: _info["title"]["rendered"],
            defaultTextStyle: titleLargeStyle,
          ), //title
        ),
        Padding(
          padding: EdgeInsets.only(left: pads, right: pads),
          child: Text(
            _info["_embedded"]["author"][0]["name"],
            style: titleNormalStyle,
          ), //author
        ),
        Padding(
          padding: EdgeInsets.only(left: pads, right: pads),
          child: Text(
            getDate(DateTime.parse(_info["date"])), //date
            style: dateStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: pads, right: pads),
          child: Html(
            data: _info["content"]["rendered"],
            defaultTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.0
            ),
            customRender: (node, children){
              if (node is dom.Element) {
                switch (node.localName) {
                  case "iframe":
                    _iframe(node);
                }
              }
            },
          ), //article content
        ),
      ],
    );
  }

  Widget _getFeaturedImage(){
    try{
      return AspectRatio(
        aspectRatio: 16.0/10.0,
        child:CachedNetworkImage(
          imageUrl: _info["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"],
          fit: BoxFit.cover,
        )
      );
    }catch(NoSuchMethodError){
      return Text("");
    }
  }

  Widget _iframe(var node){
    return new Container(
      width: MediaQuery.of(context).size.width * .75,
      child: Card(
        child: InkWell(
          onTap: () => _openYoutube(node.attributes["src"]),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width * .75,
                imageUrl: "https://img.youtube.com/vi/" + node.attributes["src"].split("/")[node.attributes["src"].split("/").length - 1] + "/1.jpg",
                fit: BoxFit.cover,
              ),
              Icon(Icons.play_circle_filled, color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }

  void _openYoutube(String url) async{
    if(await canLaunch(url))
      await launch(url);
  }

  Future<Map> fetchArticleInfo() async{
    final postInfo = await http.get("https://nashuproar.org/wp-json/wp/v2/posts/" + widget.id + "?_embed");
    return json.decode(postInfo.body);;
  }
}