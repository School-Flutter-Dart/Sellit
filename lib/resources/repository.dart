import 'cloud_firestore_provider.dart';

import 'package:sellit/models/post.dart';

class Repository{
  Stream<Post> fetchAllPosts(Category category) => firestoreProvider.fetchAllPosts(category);

  Future uploadPost(Post post) async => firestoreProvider.uploadPost(post);
}

final Repository repo = Repository();