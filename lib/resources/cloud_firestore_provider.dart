import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sellit/models/post.dart';

///This is the class where we do CRUD on Cloud Firestore.
class CloudFirestoreProvider {

  Future<List<Post>> fetchAllPosts() async {
    return Firestore.instance.collection('posts').getDocuments().then((QuerySnapshot qs) {
      var posts = List<Post>();

      for (var s in qs.documents) {
        String title = s['title'];
        String content = s['content'];
        double price = s['price'] * 1.0;
        String postId = s.documentID;

        posts.add(Post(title: title, content: content, postId: postId, price: price));
      }

      return posts;
    });
  }

  Future uploadPost(Post post) async {
    return Firestore.instance.collection('posts').document(post.postId).setData({
      'title': post.title,
      'content': post.content,
      'price': post.price,
    });
  }
}
