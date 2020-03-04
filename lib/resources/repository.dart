import 'cloud_firestore_provider.dart';

import 'package:sellit/models/post.dart';

class Repository{
  final CloudFirestoreProvider cloudFirestoreProvider = CloudFirestoreProvider();

  Future<List<Post>> fetchAllPosts() async => cloudFirestoreProvider.fetchAllPosts();

  Future uploadPost(Post post) async => cloudFirestoreProvider.uploadPost(post);
}

final Repository repo = Repository();