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
  final bool enlargeFirstPost;
  Function onMorePostsNeeded;

  PostListView({
    Key key,
    this.posts,
    this.enlargeFirstPost,
    this.onMorePostsNeeded,
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
      //itemCount: widget.posts.length,
      itemBuilder: (BuildContext context, int i){
        //need to load more posts
        if(i >= widget.posts.length)
          widget.onMorePostsNeeded();
        else{
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
                        ),
                        constraints: const BoxConstraints(maxWidth: 275.0),
                      ),
                      Text(getDate(DateTime.parse(widget.posts[i]["date"]))),
                    ],
                  ),
                ],
              )
            ),
          );
        }
      },
    );
  }


  Widget _getFeaturedImage(int index){
    try{
      return CachedNetworkImage(
          imageUrl: widget.posts[index]["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
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
            id: widget.posts[index]["id"].toString(),
          );
        }
      ),
    );
  }

}