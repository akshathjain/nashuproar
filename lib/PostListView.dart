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
      itemBuilder: (BuildContext context, int i){
        //need to load more posts
        if(i < widget.posts.length && i == 0 && widget.enlargeFirstPost){ //special enlarged first post
          return _cardLarge(i);
        }else if(i < widget.posts.length){ //normal listview post
          return _cardNormal(i);
        }else if(i == widget.posts.length){ //load more posts indicator
          if(widget.canGetMorePosts != null && widget.canGetMorePosts()){
            widget.onGetMorePosts();
            return Center(child: CircularProgressIndicator(),);
          }
        }
      },
    );
  }

  Widget _cardLarge(int i){
    return Card(
      child: InkWell(
        onTap: () => _openPost(context, i),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getFeaturedImageLarge(i),
            ConstrainedBox(
              child: Html(
                data: widget.posts[i]["title"]["rendered"],
                defaultTextStyle: titleLargeStyle
              ),
              constraints: const BoxConstraints(maxWidth: 275.0),
            ),
            Text(
              getDate(DateTime.parse(widget.posts[i]["date"])),
              style: dateStyle
            ),
          ],
        ),
      ),
    );  
  }

  Widget _cardNormal(int i){
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
                    data: widget.posts[i]["title"]["rendered"],
                    defaultTextStyle: titleNormalStyle,
                  ),
                  constraints: const BoxConstraints(maxWidth: 275.0),
                ),
                Text(
                  getDate(DateTime.parse(widget.posts[i]["date"])),
                  style: dateStyle,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _getFeaturedImage(int index){
    try{
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 130.0),
          child: AspectRatio(
            aspectRatio: 16.0/9.0,
            child: CachedNetworkImage(
              imageUrl: widget.posts[index]["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"],
              fit: BoxFit.cover,
            ),
          )
        );
    }catch(NoSuchMethodError){
      return Container();
    }
  }

  Widget _getFeaturedImageLarge(int index){
    try{
      return AspectRatio(
        aspectRatio: 16.0/9.0,
        child: CachedNetworkImage(
          imageUrl: widget.posts[index]["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["large"]["source_url"],
          fit: BoxFit.cover,
        ),
      );
    }catch(NoSuchMethodError){
      return Container();
    }
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