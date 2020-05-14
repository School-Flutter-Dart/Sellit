import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:sellit/ui/components/post_list_tile.dart';
import 'post_detail_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: ColoredTabBar(
                  Colors.blue,
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Posted',
                      ),
                      Tab(
                        text: 'Liked',
                      ),
                      Tab(
                        text: 'Sold',
                      )
                    ],
                  )),
              body: TabBarView(children: [
                FutureBuilder(
                  future: firestoreProvider.fetchPostedIds().then((ids) => firestoreProvider.fetchPostsByPostIds(ids)),
                  builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;

                      if(posts.isEmpty){
                        return Center(
                          child: Text('No posted posts'),
                        );
                      }

                      return ListView(
                        children: posts
                            .map((e) => PostListTile(
                                  post: e,
                                  onLongPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) {
                                          return CupertinoActionSheet(
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    firestoreProvider.deletePost(e).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Delete')),
                                            ],
                                          );
                                        });
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return Center(
                        child: Text('No posted items'),
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: firestoreProvider.fetchLikedIds().then((ids) => firestoreProvider.fetchPostsByPostIds(ids)),
                  builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;

                      if(posts.isEmpty){
                        return Center(
                          child: Text('No liked posts'),
                        );
                      }

                      return ListView(
                        children: posts
                            .map((e) => PostListTile(
                                  post: e,
                                  onLongPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) {
                                          return CupertinoActionSheet(
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    firestoreProvider.deleteLikedIds(e.postId).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Delete')),
                                            ],
                                          );
                                        });
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return Center(
                        child: Text('No liked posts'),
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: firestoreProvider.fetchPostedIds().then((ids) => firestoreProvider.fetchSoldPostsByPostIds(ids)),
                  builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;

                      if(posts.isEmpty){
                        return Center(
                          child: Text('No sold posts'),
                        );
                      }

                      return ListView(
                        children: posts.map((e) => PostListTile(post: e)).toList(),
                      );
                    } else {
                      return Center(
                        child: Text('No sold posts'),
                      );
                    }
                  },
                ),
              ]),
            )));
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
