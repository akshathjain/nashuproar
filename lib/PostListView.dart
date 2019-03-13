/*
Name: Akshath Jain
Date: 1/8/18
Purpose: generic class that displays a list of posts
*/

import 'package:flutter/material.dart';
import 'ArticleView.dart';
import 'package:flutter_html/flutter_html.dart';
import 'Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Colors.dart';

class PostListView extends StatefulWidget{
  List posts;
  bool enlargeFirstPost = false;
  Function canGetMorePosts;
  Function onGetMorePosts;

  PostListView({
    Key key,
    this.posts,
    this.enlargeFirstPost,
    this.canGetMorePosts,
    this.onGetMorePosts,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PostListViewState();
}

class _PostListViewState extends State<PostListView>{
  @override
  Widget build(BuildContext context) {
    if(widget.posts == null || widget.posts.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int i){
        //need to load more posts
        if(i < widget.posts.length && i == 0 && widget.enlargeFirstPost){ //special enlarged first post
          return _cardLarge(i);
        }else if(i < widget.posts.length){ //normal listview post
          return Container(
            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: _cardNormal(i)
          );
        }else if(i == widget.posts.length){ //load more posts indicator
          if(widget.canGetMorePosts != null && widget.canGetMorePosts()){
            widget.onGetMorePosts();
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator())
            );
          }
        }
      },
    );
  }

  Widget _cardNormal(int i){
    Widget image = _featuredImage(i);

    return Card(
      child: InkWell(
        onTap: () => _openPost(context, i),
        child: 
        Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                image == null ? Container() : image,
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, image== null ? 0.0 : 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Html(
                          data: widget.posts[i]["title"]["rendered"],
                          defaultTextStyle: getTitleNormalStyle(context),
                        ),
                        SizedBox(height: 2.0,),
                        _showDate(widget.posts[i]["title"]["rendered"], getDate(DateTime.parse(widget.posts[i]["date"]))),
                      ],
                    ),
                  ) 
                )
              ],
            ),
            image != null ? Container() : Html(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              data: widget.posts[i]["excerpt"]["rendered"],
              defaultTextStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? TEXT_ON_DARK : TEXT_ON_LIGHT
              ),
            ),
            SizedBox(height: image == null ? 6.0 : 0.0),
          ],
        )
        ),
    );
  }

  Widget _cardLarge(int i){
    Widget image = _featuredImageLarge(i);
    double leftRight = (image == null ? 15.0 : 20.0);

    return Card(
      child: InkWell(
        onTap: () => _openPost(context, i),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            image == null ? Container() : image,
            Padding(
              padding: EdgeInsets.fromLTRB(leftRight, 20.0, leftRight, 0.0),
              child: Html(
                data: widget.posts[i]["title"]["rendered"],
                defaultTextStyle: getTitleLargeStyle(context)
              ),
            ),
            SizedBox(height: 2.0,),
            Padding(
              padding: EdgeInsets.fromLTRB(leftRight, 0.0, leftRight, 0.0),
              child: _showDate(widget.posts[i]["title"]["rendered"], getDate(DateTime.parse(widget.posts[i]["date"]))),
            ),
            image != null ? Container() : Html(
              padding: EdgeInsets.only(left: leftRight, right: leftRight),
              data: widget.posts[i]["excerpt"]["rendered"],
              defaultTextStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? TEXT_ON_DARK : TEXT_ON_LIGHT
              ),
            ),
            SizedBox(height: image == null ? 6.0 : 20.0),
          ],
        ),
      ),
    );  
  }

  Widget _featuredImage(int index){
    try{
        return Expanded(
          flex: 1,
          child: CachedNetworkImage(
            imageUrl: widget.posts[index]["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"],
            fit: BoxFit.cover,
          ),
        );
    }catch(NoSuchMethodError){
      return null;
    }
  }

  Widget _featuredImageLarge(int index){
    try{
      return AspectRatio(
        aspectRatio: 16.0/9.0,
        child: CachedNetworkImage(
          imageUrl: widget.posts[index]["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["large"]["source_url"],
          fit: BoxFit.cover,
        ),
      );
    }catch(NoSuchMethodError){
      return null;
    }
  }

  Widget _showDate(String title, String date){
    if(title == date)
      return Container();
    
    return Text(
      date,
      style: getDateStyle(context),
    );
  }

  void _openPost(BuildContext context, int index){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new ArticleView(
            id: widget.posts[index]["id"].toString(),
          );
        }
      ),
    );
  }

}