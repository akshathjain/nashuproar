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
        title: Text("NASH Uproar"),
      ),
      body: _createBody(),
    );
  }

  Widget _getFeaturedImage(){
    try{
      return CachedNetworkImage(
          imageUrl: _info["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"],
      );
    }catch(NoSuchMethodError){
      return Text("");
    }
  }

  Widget _createBody(){
    //Case: the information still needs to be loaded
    if(_info == null){
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
    
  
    //Case: the information has already loaded
    return new ListView(
      children: <Widget>[
        _getFeaturedImage(),
        Html(
          data: _info["title"]["rendered"],
        ), //title
        Text(getDate(DateTime.parse(_info["date"]))), //date
        Text(_info["_embedded"]["author"][0]["name"]), //author
        Html(
          data: _info["content"]["rendered"],
          customRender: (node, children){
            if (node is dom.Element) {
                switch (node.localName) {
                  case "iframe":
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
              }
          },
        ), //article content
      ],
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