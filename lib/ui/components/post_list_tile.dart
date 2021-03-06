import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:sellit/models/post.dart';

import 'package:sellit/ui/post_detail_page.dart';

class PostListTile extends StatefulWidget {
  final Post post;
  final VoidCallback onLongPressed;

  PostListTile({this.post, this.onLongPressed});

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
                  child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: widget.post.imagePaths[0], fit: BoxFit.cover),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(widget.post.title),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("\$${widget.post.price.toString()}"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapped() {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PostDetailPage(post: widget.post)));
  }

  void onLongPressed() {
    widget.onLongPressed();
  }
}
