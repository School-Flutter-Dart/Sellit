import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellit/bloc/post_bloc.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/post_card.dart';
import 'post_detail_page.dart';
import 'post_edit_page.dart';

import 'register_page.dart';
import 'sign_in_page.dart';
import 'profile_page.dart';

import 'chat_home_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Post> posts = [];

  Widget child;

  double angle = 0;

  int index = 0;

  Category currentCategory = Category.all;

  @override
  void initState() {
    super.initState();

    firestoreProvider.signInUserSilently().whenComplete(() {
      setState(() {});
    });

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
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (_, AsyncSnapshot<FirebaseUser> snapshot) {
        var user = snapshot.data;
        firestoreProvider.firebaseUser = user;

        print("user is $user");
        if (user != null) {
          print('user email is ${user.email}');
        }

        return Scaffold(
            key: _scaffoldKey,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  if (firestoreProvider.firebaseUser == null) {
                    showCupertinoDialog(
                        context: context,
                        builder: (_) {
                          return CupertinoAlertDialog(
                            title: Text('You must sign in to post'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PostEditPage()));
                  }
                }),
            appBar: AppBar(
              title: Text('SellIt'),
              actions: <Widget>[
                DropdownButton<Category>(
                    selectedItemBuilder: (context) {
                      return [
                        Container(
                          width: 64,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 18),
                              child: Text(categoryToString(currentCategory)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Text(categoryToString(currentCategory)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Text(categoryToString(currentCategory)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Text(categoryToString(currentCategory)),
                        ),
                      ];
                    },
                    value: currentCategory,
                    style: TextStyle(color: Colors.white),
                    items: [
                      for (var category in Category.values)
                        DropdownMenuItem<Category>(value: category, child: Text(categoryToString(category), style: TextStyle(color: Colors.black)))
                    ],
                    onChanged: (Category category) {
                      print("current category: $category");
                      postBloc.fetchAllPosts(category: category);
                      index = 0;
                      setState(() {
                        currentCategory = category;
                      });
                    }),
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
                  ListTile(
                    title: Text(user?.displayName ?? user?.email ?? " "),
//                    title: Text(firestore_provider?.firebaseUser?.displayName ?? "Not signed in"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  if (user == null)
                    ListTile(
                      title: Text('Register'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())).then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  if (user == null)
                    ListTile(
                      title: Text('Sign In'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignInPage())).then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  if (user != null)
                    ListTile(
                      title: Text('Sign Out'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignInPage())).then((value) {
                          setState(() {});
                        });
                        firestoreProvider.signOut();
                      },
                    ),
                  ListTile(
                    title: Text('Chat'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatHomePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: StreamBuilder(
                stream: postBloc.posts,
                builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                  if (snapshot.hasData) {
                    posts = snapshot.data;

                    if (posts.isNotEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: DragTarget(
                                onAccept: (Post post) {
                                  //print("remove ${posts[index]}");
                                  //postBloc.removePosts(post);
                                },
                                builder: (_, __, ___) {
                                  return Container();
                                },
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                Draggable(
                                  data: posts[index],
                                  childWhenDragging: Transform.scale(
                                    scale: 0.9,
                                    child: PostCard(
                                      post: index + 1 < posts.length ? posts[index + 1] : posts[0],
                                    ),
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
                                      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PostDetailPage(post: posts[index])));
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
                                onAccept: onLiked,
                                builder: (_, __, ___) {
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('No posts'),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }));
      },
    );
  }

  void onLiked(Post post) {
    print("liked ${post.title}");
    firestoreProvider.addLikedPost(post);
  }

  void onDragStarted() {
    print("asd");
  }

  void onPanStart(DragStartDetails details) {
    print(details.localPosition);
  }
}
