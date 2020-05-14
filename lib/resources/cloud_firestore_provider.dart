import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellit/models/chat.dart';
import 'package:sellit/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:sellit/models/post.dart';

export 'package:sellit/models/post.dart';

class CloudFirestoreProvider {
  FirebaseUser firebaseUser;

  Stream<Chat> fetchAllChats() async* {
    var snap = await Firestore.instance.collection('users').document(firebaseUser.uid).get();
    var map = snap.data;
    var chatIds = map['chats'] ?? [];
    for (var id in chatIds) {
      var querySnapshots = await Firestore.instance.collection(messagesKey).document(id).collection(messagesKey).getDocuments();
      var snapshot = await Firestore.instance.collection(messagesKey).document(id).get();
      var id1 = snapshot.data['participant1'];
      var id2 = snapshot.data['participant2'];

      if (querySnapshots.documents.isEmpty) {
        yield Chat(messages: [], uid: firebaseUser.uid == id1 ? id2 : id1);
      }

      var msg = querySnapshots.documents.first.data[msgTextKey];
      var senderId = querySnapshots.documents.first.data[senderIdKey];
      var timestamp = querySnapshots.documents.first.data[timestampKey];
      var message = Message(text: msg, timestamp: timestamp, senderId: senderId);
      yield Chat(messages: [message], uid: firebaseUser.uid == id1 ? id2 : id1);
    }
  }

  Future<String> fetchUserNameByUid(String uid) async {
    var snapshot = await Firestore.instance.collection('users').document(uid).get();
    return snapshot.data['displayName'];
  }

  Stream<List<Message>> getMessageStream(String otherUid) {
    String documentId = firebaseUser.uid + otherUid;

    if (otherUid.compareTo(firebaseUser.uid) == -1) {
      documentId = otherUid + firebaseUser.uid;
    }

    print("documentId is $documentId");

    Firestore.instance.collection(msgKey).document(documentId).collection(msgKey).add({});

    return Firestore.instance
        .collection(msgKey)
        .document(documentId)
        .collection(msgKey)
        .orderBy(timestampKey, descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.documents.map((doc) {
        var map = doc.data;
        map[isSelfKey] = map[senderIdKey] == firebaseUser.uid;
        var msg = Message.fromMap(map);
        print(msg);
        return msg;
      }).toList();
    });
  }

  Stream<Post> fetchAllPosts(Category category) async* {
    var qs = await Firestore.instance.collection('posts').where('isSold', isEqualTo: false).getDocuments();

    var posts = List<Post>();

    for (var s in category == Category.all ? qs.documents : qs.documents.where((s) => (s['categoryIndex'] ?? 0) == category.index)) {
      print("isSold false");
      print(s.documentID);

      s.data['id'] = s.documentID;

      List<String> imagePaths = s['imagePaths'] == null ? [] : (s['imagePaths'] as List).cast<String>();

      var paths = [];

      yield await Future.forEach(imagePaths, (path) async {
        var reference = FirebaseStorage.instance.ref().child(path);
        var p = await reference.getDownloadURL();
        paths.add(p);
      }).then((_) {
        Map map = Map.from(s.data);
        map['imagePaths'] = paths;
        map['id'] = s.documentID;

        return Post.fromMap(map);
      });
    }
  }

  Stream<Post> fetchLikedPosts() async* {
    var docSnapshot = await Firestore.instance.collection('users').document(firebaseUser.uid).get();
    var likeIds = docSnapshot.data['likedIds'];
    for (var id in likeIds) {
      var ds = await Firestore.instance.collection('posts').document(id).get();
      var s = ds.data;
      List<String> imagePaths = s['imagePaths'] == null ? [] : (s['imagePaths'] as List).cast<String>();
      print(imagePaths.length);

      Status status = Status.values.elementAt(s['statusIndex']);
      String title = s['title'];
      String content = s['content'];
      Category category = Category.values.elementAt(s['categoryIndex']);
      double price = s['price'] * 1.0;
      String postId = ds.documentID;
      String postUserUid = s['postUserUid'];
      String postUserDisplayName = s['postUserDisplayName'];

      DateTime postedDate = DateTime.parse(s['postedDate'] ?? "2020-04-09").toLocal();

      yield Post(
          //status: status,
          title: title,
          content: content,
          category: category,
          postId: postId,
          price: price,
          postUserId: postUserUid,
          postUserDisplayName: postUserDisplayName,
          postedDate: postedDate,
          imagePaths: imagePaths);
    }
  }

  Future<List<int>> getImageBytesByPath(String path) async {
    print("the path is $path");
    var reference = FirebaseStorage.instance.ref().child(path);
    var imageBytes = await reference.getData(5000000);
    return imageBytes;
  }

  Future addLikedPost(Post post) async {
    if (firebaseUser != null && post.postId != null) {
      return Firestore.instance.collection('users').document(firebaseUser.uid).updateData({
        'likedIds': FieldValue.arrayUnion([post.postId])
      });
    }
  }

  static bool hasImage(List<List<int>> imageBytes) {
    for (var bytes in imageBytes) {
      if (bytes != null) {
        return true;
      }
    }
    return false;
  }

  Future deletePost(Post post) async {
    Firestore.instance.collection(usersKey).document(firebaseUser.uid).updateData({
      'postedIds': FieldValue.arrayRemove([post.postId])
    });
    return Firestore.instance.collection('posts').document(post.postId).delete();
  }

  Future markAsSold(Post post) async {
    print(post.postId);
    return Firestore.instance.collection('posts').document(post.postId).updateData({'isSold': true});
  }

  Future fetchSoldPosts() async {}

  Future uploadPost(Post post) async {
    List<String> imagePaths = [];
    for (int i = 0; i < post.imageBytes.length; i++) {
      if (post.imageBytes[i] != null) {
        String path = post.postId + i.toString();
        print(path);
        imagePaths.add(path);
        final StorageReference storageReference = FirebaseStorage().ref().child(path);

        final StorageUploadTask uploadTask = storageReference.putData(post.imageBytes[i]);

        final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
          // You can use this to notify yourself or your user in any kind of way.
          // For example: you could use the uploadTask.events stream in a StreamBuilder instead
          // to show your user what the current status is. In that case, you would not need to cancel any
          // subscription as StreamBuilder handles this automatically.

          // Here, every StorageTaskEvent concerning the upload is printed to the logs.
          print('======================EVENT ${event.type} ======================');
        });

// Cancel your subscription when done.
        await uploadTask.onComplete;
        streamSubscription.cancel();
      } else {
        break;
      }
    }

    return Firestore.instance.collection('posts').document(post.postId).setData({
      'postUserUid': post.postUserId,
      'postUserDisplayName': post.postUserDisplayName,
      'postedDate': post.postedDate.toUtc().toString(),
      'categoryIndex': post.category.index,
      'title': post.title,
      'content': post.content,
      'price': post.price,
      'imagePaths': imagePaths,
      'isSold': false
    }).whenComplete(() {
      Firestore.instance.collection('users').document(firebaseUser.uid).updateData({
        'postedIds': FieldValue.arrayUnion([post.postId])
      });
    });
  }

  Future uploadUser(FirebaseUser firebaseUser) async {
    return Firestore.instance.collection('users').document(firebaseUser.uid).setData({
      'email': firebaseUser.email,
      'displayName': firebaseUser.displayName,
    });
  }

  Future fetchLikedCount() async {
    return Firestore.instance.collection('users').document(firebaseUser.uid).get().then((snapshot) {
      return (snapshot.data['likedIds'] ?? []).length;
    });
  }

  Future<List<String>> fetchLikedIds() async {
    return Firestore.instance.collection('users').document(firebaseUser.uid).get().then((snapshot) {
      return (snapshot.data['likedIds'] as List).cast<String>();
    });
  }

  Future<List<String>> fetchPostedIds() async {
    return Firestore.instance.collection('users').document(firebaseUser.uid).get().then((snapshot) {
      return (snapshot.data['postedIds'] as List).cast<String>();
    });
  }

  Future deleteLikedIds(String idToBeRemoved) async {
    var snapshot = await Firestore.instance.collection(usersKey).document(firebaseUser.uid).get();
    var ids = (snapshot.data['likedIds'] as List).cast<String>();
    ids.remove(idToBeRemoved);
    return Firestore.instance.collection(usersKey).document(firebaseUser.uid).updateData({'likedIds': ids});
  }

  Future<List<Post>> fetchSoldPostsByPostIds(List<String> ids) async {
    List<Post> posts = [];

    print(ids);

    for (var id in ids) {
      if ((await Firestore.instance.collection(postsKey).document(id).get()).exists) {
        var post = await Firestore.instance.collection('posts').document(id).get().then((s) async {
          List<String> imagePaths = s['imagePaths'] == null ? [] : (s['imagePaths'] as List).cast<String>();

          String title = s['title'];
          String content = s['content'];
          double price = s['price'] * 1.0;
          Category category = Category.values.elementAt(s['categoryIndex'] ?? 0);
          String postId = s.documentID;
          String postUserUid = s['postUserUid'];
          String postUserDisplayName = s['postUserDisplayName'];
          DateTime postedDate = DateTime.parse(s['postedDate'] ?? "2020-04-09").toLocal();
          bool isSold = s['isSold'] ?? false;

          print("id: $postId, sold: ${s['isSold']}");

          for (int i = 0; i < imagePaths.length; i++) {
            var reference = FirebaseStorage.instance.ref().child(imagePaths[i]);
            imagePaths[i] = await reference.getDownloadURL();
          }

          return Post(
              title: title,
              content: content,
              postId: postId,
              price: price,
              category: category,
              postUserId: postUserUid,
              postUserDisplayName: postUserDisplayName,
              postedDate: postedDate,
              imagePaths: imagePaths,
              isSold: isSold);
        });

        if (post.isSold == false)
          continue;
        else
          posts.add(post);
      }
    }

    return posts;
  }

  Future<List<Post>> fetchPostsByPostIds(List<String> ids) async {
    List<Post> posts = [];

    for (var id in ids) {
      print((await Firestore.instance.collection(postsKey).document(id).get()).exists);
      if ((await Firestore.instance.collection(postsKey).document(id).get()).exists) {
        var post = await Firestore.instance.collection('posts').document(id).get().then((s) async {
          List<String> imagePaths = s['imagePaths'] == null ? [] : (s['imagePaths'] as List).cast<String>();

          String title = s['title'];
          String content = s['content'];
          double price = s['price'] * 1.0;
          Category category = Category.values.elementAt(s['categoryIndex'] ?? 0);
          String postId = s.documentID;
          String postUserUid = s['postUserUid'];
          String postUserDisplayName = s['postUserDisplayName'];
          DateTime postedDate = DateTime.parse(s['postedDate'] ?? "2020-04-09").toLocal();

          for (int i = 0; i < imagePaths.length; i++) {
            var reference = FirebaseStorage.instance.ref().child(imagePaths[i]);
            imagePaths[i] = await reference.getDownloadURL();
          }

          return Post(
              title: title,
              content: content,
              postId: postId,
              price: price,
              category: category,
              postUserId: postUserUid,
              postUserDisplayName: postUserDisplayName,
              postedDate: postedDate,
              imagePaths: imagePaths);
        });

        posts.add(post);
      }
    }

    return posts;
  }

  Future<FirebaseUser> registerNewUser(String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((AuthResult authResult) {
      //verify email address
      authResult.user.sendEmailVerification();

      UserUpdateInfo updateInfo = UserUpdateInfo();

      /*The SJSU email format is FiretName.LasName@SJSU.com,
        Therefore we directly take the name from the email address provided using regular expression.
         */
      String nameString = RegExp(r'^[a-zA-Z0-9_.+-]+(?=@)').firstMatch(email).group(0).trim();
      List<String> strs = nameString.split(".");
      String firstName = strs[0];
      String lastName = strs[1];
      firstName = firstName[0].toUpperCase() + firstName.substring(1, firstName.length).toLowerCase();
      lastName = lastName[0].toUpperCase() + lastName.substring(1, lastName.length).toLowerCase();

      updateInfo.displayName = firstName + " " + lastName;

      saveEmailAndPassword(email, password);

      //Update the profile using the name we got from email.
      return authResult.user.updateProfile(updateInfo).then((value) {
        firebaseUser = authResult.user;

        //upload user data onto Cloud Firestore
        uploadUser(firebaseUser);

        return firebaseUser;
      });
      return authResult.user;
    });
  }

  Future<FirebaseUser> signInUser(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((AuthResult authResult) async {
      if (authResult.user.isEmailVerified || authResult.user.email == 'test@sjsu.edu') {
        firebaseUser = authResult.user;
        return firebaseUser;
      } else {
        firebaseUser = authResult.user;
        return firebaseUser;
        // return Future.value(null);
      }
    }).catchError((Object err) {
      print(err);
      throw err;
    });
  }

  ///Sign in user silently if previously signed in.
  Future<FirebaseUser> signInUserSilently() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String email = sharedPrefs.getString('email');
    String password = sharedPrefs.getString('password');
    print(email);
    if (email != null && password != null) {
      print(email);
      return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((AuthResult authResult) {
        firebaseUser = authResult.user;
        return firebaseUser;
      }).catchError((_) {});
    } else {
      return Future.value(null);
    }
  }

  Future signOut() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove('email');
    sharedPrefs.remove('password');
    firebaseUser = null;
    FirebaseAuth.instance.signOut();
  }

  Future forgetPassword(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future initChat(String uid) async {
    String documentId = firebaseUser.uid + uid;

    if (uid.compareTo(firebaseUser.uid) == -1) {
      documentId = uid + firebaseUser.uid;
    }

    var ref = Firestore.instance.collection('messages').document(documentId);
    var exists = (await ref.get()).exists;
    if (exists) {
      ref.collection('messages').add({});
    } else {
      //If the chat does not exist, we save the chat id to users profile and receiver's profile
      var usersRef = Firestore.instance.collection('users').document(firebaseUser.uid);
      var userRef2 = Firestore.instance.collection('users').document(uid);
      usersRef.updateData({
        'chats': FieldValue.arrayUnion([documentId])
      });
      userRef2.updateData({
        'chats': FieldValue.arrayUnion([documentId])
      });

      ref.setData({'participant1': firebaseUser.uid, 'participant2': uid});
      ref.collection('messages').add({});
    }
  }

  Future sendMessage(String message, String uid) async {
    String documentId = firebaseUser.uid + uid;

    if (uid.compareTo(firebaseUser.uid) == -1) {
      documentId = uid + firebaseUser.uid;
    }

    var ref = Firestore.instance.collection('messages').document(documentId);
    var exists = (await ref.get()).exists;
    if (exists) {
      ref.collection('messages').add({'sender': firebaseUser.uid, 'text': message, 'timestamp': DateTime.now().millisecondsSinceEpoch});
    } else {
      //If the chat does not exist, we save the chat id to users profile and receiver's profile
      var usersRef = Firestore.instance.collection('users').document(firebaseUser.uid);
      var userRef2 = Firestore.instance.collection('users').document(uid);
      usersRef.updateData({
        'chats': FieldValue.arrayUnion([documentId])
      });
      userRef2.updateData({
        'chats': FieldValue.arrayUnion([documentId])
      });

      ref.setData({'participant1': firebaseUser.uid, 'participant2': uid});
      ref.collection('messages').add({'sender': firebaseUser.uid, 'text': message, 'timestamp': DateTime.now().millisecondsSinceEpoch});
    }
  }

  ///Store the email and password in shared preferences
  static Future saveEmailAndPassword(String email, String password) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(emailKey, email);
    sharedPrefs.setString(pwKey, password);
  }
}

final firestoreProvider = CloudFirestoreProvider();

const String isSelfKey = 'isSelf';
const String usersKey = 'users';
const String messagesKey = 'messages';
const String postsKey = 'posts';
const String chatsKey = 'chats';
const String senderIdKey = 'sender';
const String msgKey = 'messages';
const String timestampKey = 'timestamp';
const String emailKey = 'emailKey';
const String pwKey = 'password';
const String msgTextKey = 'text';
