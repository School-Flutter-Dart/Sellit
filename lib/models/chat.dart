import 'message.dart';

class Chat{
  List<Message> messages;

  ///The uid of the other user.
  String uid;

  ///The username of the other user.
  String userName;


  Chat({this.messages, this.uid, this.userName});
}