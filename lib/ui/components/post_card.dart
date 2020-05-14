import 'package:flutter/material.dart';

import 'package:sellit/models/post.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:transparent_image/transparent_image.dart';
export 'package:sellit/models/post.dart';

class PostCard extends StatefulWidget {
  final Color color;
  final Post post;

  PostCard({this.color, this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: ClipRRect(
                child: widget.post.imagePaths == null || widget.post.imagePaths.isEmpty
                    ? Image.asset("assets/turtlerock.jpg", fit: BoxFit.cover)
                    : FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.post.imagePaths[0],
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width * 0.8,
                      ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "${widget.post.title}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "${widget.post.content}",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "\$${widget.post.price.toString()}",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12, right: 12),
                child: Text(
                  "Posted by ${widget.post.postUserDisplayName ?? "Null"}",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
