import 'package:flutter/material.dart';

import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:sellit/ui/components/post_list_tile.dart';
import 'post_detail_page.dart';
import 'User_Info.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar:AppBar(
          title: Text("Home"),
//          leading: GestureDetector(
//            onTap: () { /* Write listener code here */ },
//            child: Icon(
//              Icons.menu,  // add custom icons also
//            ),
//          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {_scaffoldKey.currentState.openEndDrawer();
                  print("button pressed");},
                  child: Icon(
                      Icons.more_vert
                  ),
                )
            ),
          ],
        ),
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Profile Information'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape:BoxShape.rectangle,
                ),
              ),
              ListTile(
                title: Text('Personal'),
                onTap: () {

                  // Update the state of the app.
                  // ...
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => User_Info())).then((value) {
                  setState(() {});
                  });
                },
              ),
            ],
          ),
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
                      ),
                    ],
                  ),
              ),
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
              ])
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
