import 'package:flutter/material.dart';

import 'package:sellit/bloc/msg_bloc.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:sellit/ui/chat_page.dart';

class ChatHomePage extends StatefulWidget {
  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  void initState() {
    msgBloc.fetchAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: msgBloc.chats,
        builder: (_, AsyncSnapshot<List<Chat>> snapshot) {
          if (snapshot.hasData) {
            var chats = snapshot.data;

            return ListView(
              children: chats.map((chat) {
                return ChatListTile(uid: chat.uid);
              }).toList(),
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final String uid;

  ChatListTile({this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreProvider.fetchUserNameByUid(uid),
      builder: (_, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          var name = snapshot.data;

          return ListTile(
            title: Text(name),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(otherUid: uid)));
            },
          );
        }
        return Container();
      },
    );
  }
}
