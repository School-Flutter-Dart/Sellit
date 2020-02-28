import 'package:uuid/uuid.dart';

enum Category { test }


class Post{
  String title;
  String content;
  double price;
  String postId;
  String postUserId;

  Post({this.content, this.title, this.postId, this.postUserId, this.price});

  Post.createNewPost({this.content, this.title, this.postUserId, this.price}):postId = Uuid().v4();
}