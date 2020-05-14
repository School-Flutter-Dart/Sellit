import 'package:rxdart/rxdart.dart';

import 'package:sellit/models/message.dart';
import 'package:sellit/models/chat.dart';
import 'package:sellit/resources/cloud_firestore_provider.dart';
import 'package:sellit/resources/repository.dart';

export 'package:sellit/models/message.dart';
export 'package:sellit/models/chat.dart';

class MsgBloc {
  BehaviorSubject<List<Message>> _messagesFetcher = BehaviorSubject<List<Message>>();
  BehaviorSubject<List<Chat>> _chatsFetcher = BehaviorSubject<List<Chat>>();

  List<Message> _messagesCache = [];
  List<Chat> _chatsCache = [];

  Stream<List<Message>> get messages => _messagesFetcher.stream;
  Stream<List<Chat>> get chats => _chatsFetcher.stream;

//  void fetchAllMessagesById(String uid) {
//    _messagesCache.clear();
//    firestore_provider.fetchAllMessages(uid).listen((msg) {
//      _messagesCache.add(msg);
//      _messagesFetcher.sink.add(_messagesCache);
//    });
//  }

  void fetchAllChats() {
    _chatsCache.clear();
    firestoreProvider.fetchAllChats().listen((chat) {
      _chatsCache.add(chat);
      _chatsFetcher.sink.add(_chatsCache);
    });
  }

  void sendMessage(String text, String otherUid) {
    firestoreProvider.sendMessage(text, otherUid);
  }

  void reset(){

  }

  dispose() {
    _messagesFetcher.close();
    _chatsFetcher.close();
  }
}

final msgBloc = MsgBloc();
