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
  String postUserDisplayName;
  ///The bytes data of images of the post.
  List<List<int>> imageBytes;
  List<String> imagePaths;

  DateTime postedDate;

  Post({this.content, this.title, this.postId, this.postUserId, this.postUserDisplayName,this.price, this.postedDate, this.imageBytes, this.imagePaths});

  Post.createNewPost({this.content, this.title, this.postUserId, this.postUserDisplayName,this.price}):postId = Uuid().v4(), postedDate = DateTime.now();
}