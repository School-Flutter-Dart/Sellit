import 'package:flutter/material.dart';

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
    return Hero(
      tag: "main",
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
                  child: Text(widget.post.title, style: TextStyle(color: Colors.white, fontSize: 24),),
                )
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child:Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(widget.post.content, style: TextStyle(color: Colors.white, fontSize: 20),),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
