import 'package:flutter/material.dart';

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
                        text: 'Sold',
                      ),
                      Tab(
                        text: 'Liked',
                      ),
                      Tab(
                        text: 'Bought',
                      )
                    ],
                  )),
              body: TabBarView(children: [
                FutureBuilder(
                  future: firestore_provider.fetchLikedIds().then((ids) => firestore_provider.fetchPostsByPostIds(ids)),
                  builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;

                      return ListView(
                        children: posts.map((e) => PostListTile(post: e)).toList(),
                      );
                    } else {
                      return Center(
                        child: Text('No liked posts'),
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: firestore_provider.fetchLikedIds().then((ids) => firestore_provider.fetchPostsByPostIds(ids)),
                  builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;

                      return ListView(
                        children: posts.map((e) => PostListTile(post: e)).toList(),
                      );
                    } else {
                      return Center(
                        child: Text('No liked posts'),
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: firestore_provider.fetchLikedIds().then((ids) => firestore_provider.fetchPostsByPostIds(ids)),
                  builder: (_, AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasData) {
                      var posts = snapshot.data;

                      return ListView(
                        children: posts.map((e) => PostListTile(post: e)).toList(),
                      );
                    } else {
                      return Center(
                        child: Text('No liked posts'),
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
