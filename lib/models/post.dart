import 'package:uuid/uuid.dart';

enum Category { test }


class Post{
  ///The title of the post.
  String title;

  ///The content of post.
  String content;
  double price;
  String postId;
  String postUserId;
  ///The bytes data of images of the post.
  List<List<int>> imageBytes;

  Post({this.content, this.title, this.postId, this.postUserId, this.price});

  Post.createNewPost({this.content, this.title, this.postUserId, this.price}):postId = Uuid().v4();
}