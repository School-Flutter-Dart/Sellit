import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:sellit/ui/chat_page.dart';
import 'package:sellit/ui/post_edit_page.dart';

import 'package:transparent_image/transparent_image.dart';

import 'package:sellit/bloc/post_bloc.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage({this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Color appBarColor = Colors.transparent;
  String currentImageUrl;
  int imageCount;

  @override
  void initState() {
    super.initState();
    if (widget.post.imagePaths != null && widget.post.imagePaths.isNotEmpty) {
      imageCount = widget.post.imagePaths.length;
      currentImageUrl = widget.post.imagePaths.first;
    } else {
      imageCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var path in widget.post.imagePaths) {
      precacheImage(FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: path, fit: BoxFit.cover).image, context);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      floatingActionButton: Opacity(
        opacity: firestoreProvider.firebaseUser == null ? 0 : 1,
        child: firestoreProvider.firebaseUser != null && widget.post.postUserId == firestoreProvider.firebaseUser.uid
            ? FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (_) {
                        return CupertinoActionSheet(
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => PostEditPage(postToBeEdited: widget.post)));
                                },
                                child: Text('Edit')),
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  firestoreProvider.markAsSold(widget.post);
                                  Navigator.pop(context);
                                },
                                child: Text('Mark As Sold')),
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  firestoreProvider.deletePost(widget.post);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                isDestructiveAction: true,
                                child: Text('Delete')),
                          ],
                        );
                      });
                })
            : FloatingActionButton(
                child: Icon(Icons.chat),
                onPressed: () {
                  print("The other id is ${widget.post.postUserId}");
                  firestoreProvider.initChat(widget.post.postUserId).whenComplete(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatPage(
                                  otherUid: widget.post.postUserId,
                                )));
                  });
                }),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var path in widget.post.imagePaths)
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: path, fit: BoxFit.cover)),
                    ],
                  )),
            ),
            Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "\$${widget.post.price.toString()}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.post.title,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.post.content,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
