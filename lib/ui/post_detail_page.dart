import 'package:flutter/material.dart';

import 'package:sellit/bloc/post_bloc.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage({this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Color appBarColor = Colors.transparent;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/turtlerock.jpg', fit: BoxFit.cover,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
