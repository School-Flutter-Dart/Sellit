import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/post_card.dart';
import 'post_detail_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();

  List<Widget> cards = <Widget>[
    PostCard(
      color: Colors.black12,
      post: Post.createNewPost(title: "Something", price: 2.99, content: "this works great"),
    ),
    PostCard(
      color: Colors.pink,
      post: Post.createNewPost(title: "Something", price: 12.99, content: "this works great"),
    ),
    PostCard(
      color: Colors.purple,
      post: Post.createNewPost(title: "Something", price: 12.99, content: "this works great"),
    ),
    PostCard(
      color: Colors.tealAccent,
      post: Post.createNewPost(title: "Something", price: 12.99, content: "this works great"),
    ),
  ];

  Widget child;

  double angle = 0;

  int index = 0;

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      setState(() {
        print("The offset is ${pageController.offset}");
        angle = pageController.offset * (pi / 2);
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Stack(
                children: <Widget>[
                  Draggable(
                    childWhenDragging: Transform.scale(
                      scale: 0.9,
                      child: index + 1 < cards.length ? cards[index + 1] : cards[0],
                    ),
                    feedback: cards[index],
                    onDragStarted: onDragStarted,
                    onDragCompleted: () {
                      if (index + 1 < cards.length) {
                        setState(() {
                          ++index;
                        });
                      } else {
                        setState(() {
                          index = 0;
                        });
                      }
                    },
                    onDragEnd: (_) {},
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PostDetailPage(color: Colors.blue)));
                      },
                      child: Hero(
                        tag: "main",
                        child: cards[index],
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                flex: 1,
                child: DragTarget(
                  onAccept: (_) {
                    print("accepted");
                  },
                  builder: (_, __, ___) {
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ));
  }

  void onDragStarted() {
    print("asd");
  }

  void onPanStart(DragStartDetails details) {
    print(details.localPosition);
  }
}
