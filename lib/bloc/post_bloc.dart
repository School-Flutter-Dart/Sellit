import 'package:rxdart/rxdart.dart';

import 'package:sellit/models/post.dart';
import 'package:sellit/resources/repository.dart';

export 'package:sellit/models/post.dart';

class PostBloc{
  BehaviorSubject<List<Post>> _postsFetcher = BehaviorSubject<List<Post>>();

  List<Post> _posts = [];

  Stream<List<Post>> get posts => _postsFetcher.stream;

  void fetchAllPosts(){
    repo.fetchAllPosts().listen((data){
      _posts.add(data);
      _postsFetcher.sink.add(_posts);
    });
  }

  void uploadPost(Post post){
    repo.uploadPost(post).whenComplete((){
      postBloc.fetchAllPosts();
    });
//
//    _posts.add(post);
//
//    _postsFetcher.sink.add(_posts);
  }

  dispose(){
    _postsFetcher.close();
  }
}

final PostBloc postBloc = PostBloc();