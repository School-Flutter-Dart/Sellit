import 'package:flutter/material.dart';

import 'package:sellit/models/post.dart';

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
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Container(
                width: double.infinity,
                child: ClipRRect(
                  child: Image.asset("assets/turtlerock.jpg", fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "${widget.post.title}",
                    style: TextStyle(fontSize: 24, backgroundColor: Colors.black54),
                  ),
                )),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "${widget.post.content}",
                    style: TextStyle(fontSize: 18),
                  ),
                )),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "\$${widget.post.price.toString()}",
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 0, left: 12),
              child: Text(
                "Posted by ${widget.post.postUserDisplayName ?? "Null"}",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      ),
    );
  }
}
