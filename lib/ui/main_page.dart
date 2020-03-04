import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellit/bloc/post_bloc.dart';

import 'components/post_card.dart';
import 'post_detail_page.dart';
import 'post_edit_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Post> posts = [];

//  List<Widget> cards = <Widget>[
//    PostCard(
//      color: Colors.black12,
//      post: Post.createNewPost(title: "Something", price: 2.99, content: "this works great"),
//    ),
//    PostCard(
//      color: Colors.pink,
//      post: Post.createNewPost(title: "Something", price: 12.99, content: "this works great"),
//    ),
//    PostCard(
//      color: Colors.purple,
//      post: Post.createNewPost(title: "Something", price: 12.99, content: "this works great"),
//    ),
//    PostCard(
//      color: Colors.tealAccent,
//      post: Post.createNewPost(title: "Something", price: 12.99, content: "this works great"),
//    ),
//  ];

  Widget child;

  double angle = 0;

  int index = 0;

  @override
  void initState() {
    super.initState();

//    Firestore.instance.collection('books').document()
//        .setData({ 'title': 'title', 'author': 'author' });

    postBloc.fetchAllPosts();

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
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PostEditPage()));
        }),
        appBar: AppBar(
          title: Text('SellIt'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: postBloc.posts,
          builder: (_, AsyncSnapshot<List<Post>> snapshot){
            if(snapshot.hasData){
              posts = snapshot.data;

              if(posts.isNotEmpty){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: DragTarget(
                          onAccept: (_) {
                            print("unliked");
                          },
                          builder: (_, __, ___) {
                            return Container();
                          },
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Draggable(
                            childWhenDragging: Transform.scale(
                              scale: 0.9,
                              child: PostCard(post: index + 1 < posts.length ? posts[index + 1] : posts[0],),
                            ),
                            feedback: PostCard(post: posts[index]),
                            onDragStarted: onDragStarted,
                            onDragCompleted: () {
                              if (index + 1 < posts.length) {
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
                                child: PostCard(post: posts[index]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        flex: 1,
                        child: DragTarget(
                          onAccept: (_) {
                            print("liked");
                          },
                          builder: (_, __, ___) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }else{
                return Center(
                  child: Text('No posts'),
                );
              }
            }else{
              return CircularProgressIndicator();
            }
          }
        ));
  }

  void onDragStarted() {
    print("asd");
  }

  void onPanStart(DragStartDetails details) {
    print(details.localPosition);
  }
}
