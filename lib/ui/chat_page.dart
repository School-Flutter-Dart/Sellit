import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sellit/bloc/msg_bloc.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';

class ChatPage extends StatefulWidget {
  final String otherUid;

  ChatPage({this.otherUid});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Message>>(
          stream: firestoreProvider.getMessageStream(widget.otherUid),
          initialData: [Message(text: 'test - this means no messages exist', isSelf: true)],
          builder: (_, AsyncSnapshot<List<Message>> snapshot) {
            var msgs = snapshot.data ?? [];
            print(msgs);
            return Container(
              color: Colors.lightBlue,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 64,
                    child: ListView(
                      shrinkWrap: true,
                      reverse: true ,
                      children: msgs.map((msg) {
                        if (msg.isSelf) {
                          return Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3, right: 12, top: 4, bottom: 4),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white70,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    msg.text,
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.3, left: 12, top: 4, bottom: 4),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white70,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(msg.text),
                                )),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.lightBlueAccent,
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width - 48,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: TextField(
                                    controller: editingController,
                                    decoration: InputDecoration(hintText: "Enter message here", border: InputBorder.none),
                                  ),
                                )),
                            Container(
                              width: 48,
                              child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  if (editingController.text.trim().isNotEmpty) {
                                    msgBloc.sendMessage(editingController.text.trim(), widget.otherUid);
                                    editingController.clear();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            );
          }),
    );
  }
}
