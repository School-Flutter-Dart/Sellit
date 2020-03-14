import 'cloud_firestore_provider.dart';

import 'package:sellit/models/post.dart';

class Repository{
  Future<List<Post>> fetchAllPosts() async => firestore_provider.fetchAllPosts();

  Future uploadPost(Post post) async => firestore_provider.uploadPost(post);
}

final Repository repo = Repository();