import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sellit/models/post.dart';

import 'package:sellit/ui/post_detail_page.dart';

class PostListTile extends StatefulWidget {
  final Post post;

  PostListTile({this.post});

  @override
  _PostListTileState createState() => _PostListTileState();
}

class _PostListTileState extends State<PostListTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: InkWell(
          onTap: onTapped,
          onLongPress: onLongPressed,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/turtlerock.jpg'),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    widget.post.title
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                      widget.post.price.toString()
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapped(){
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PostDetailPage(post: widget.post)));
  }

  void onLongPressed(){

  }
}
