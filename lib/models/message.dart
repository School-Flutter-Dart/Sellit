import 'dart:core';

import 'package:sellit/models/user.dart';

//Still need to adjust for using Firebase
class Message {
  final String senderId;
  final int timestamp;
  final String text;
  final bool isSelf;

  Message({this.senderId, this.timestamp, this.text, this.isSelf});

  Message.fromMap(Map map)
      : senderId = map['sender'],
        timestamp = map['timestamp'],
        text = map['text'],
        isSelf = map['isSelf'];

  String toString() {
    return 'Instance of Message: text: $text';
  }
}
