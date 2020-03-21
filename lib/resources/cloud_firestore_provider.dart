import 'dart:core';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sellit/models/post.dart';

export 'package:sellit/models/post.dart';

///This is the class where we do CRUD on Cloud Firestore.
class CloudFirestoreProvider {
  FirebaseUser firebaseUser;

  Future<List<Post>> fetchAllPosts() async {
    return Firestore.instance.collection('posts').getDocuments().then((QuerySnapshot qs) {
      var posts = List<Post>();

      for (var s in qs.documents) {
        String title = s['title'];
        String content = s['content'];
        double price = s['price'] * 1.0;
        String postId = s.documentID;
        String postUserUid = s['postUserUid'];
        String postUserDisplayName = s['postUserDisplayName'];
        DateTime postedDate = DateTime.parse(s['postedDate'] ?? "2020-04-09").toLocal();

        posts.add(Post(
            title: title,
            content: content,
            postId: postId,
            price: price,
            postUserId: postUserUid,
            postUserDisplayName: postUserDisplayName,
            postedDate: postedDate));
      }

      return posts;
    });
  }

  Future addLikedPost(Post post) async {
    if (firebaseUser != null) {
      return Firestore.instance.collection('users').document(firebaseUser.uid).updateData({
        'likedIds': FieldValue.arrayUnion([post.postId])
      });
    }
  }

  Future uploadPost(Post post) async {
    return Firestore.instance.collection('posts').document(post.postId).setData({
      'postUserUid': post.postUserId,
      'postUserDisplayName': post.postUserDisplayName,
      'postedDate': post.postedDate.toUtc().toString(),
      'title': post.title,
      'content': post.content,
      'price': post.price,
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

  Future<List<String>> fetchLikedIds() async{
    return Firestore.instance.collection('users').document(firebaseUser.uid).get().then((snapshot) {
      return (snapshot.data['likedIds'] as List).cast<String>();
    });
  }

  Future<List<Post>> fetchPostsByPostIds(List<String> ids) async {
    List<Post> posts = [];

    for (var id in ids) {
      var post = await Firestore.instance.collection('posts').document(id).get().then((s) {
        String title = s['title'];
        String content = s['content'];
        double price = s['price'] * 1.0;
        String postId = s.documentID;
        String postUserUid = s['postUserUid'];
        String postUserDisplayName = s['postUserDisplayName'];
        DateTime postedDate = DateTime.parse(s['postedDate'] ?? "2020-04-09").toLocal();

        return Post(
            title: title,
            content: content,
            postId: postId,
            price: price,
            postUserId: postUserUid,
            postUserDisplayName: postUserDisplayName,
            postedDate: postedDate);
      });

      posts.add(post);
    }

    return posts;
  }

  Future<FirebaseUser> registerNewUser(String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((AuthResult authResult) {
      //verify email address
      authResult.user.sendEmailVerification();

      return authResult.user;
    });
  }

  Future<FirebaseUser> signInUser(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((AuthResult authResult) async {
      if (authResult.user.isEmailVerified) {
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
      } else {
        firebaseUser = authResult.user;
        return Future.value(null);
      }
    });
  }

  ///Sign in user silently if previously signed in.
  Future<FirebaseUser> signInUserSilently() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String email = sharedPrefs.getString('email');
    String password = sharedPrefs.getString('password');

    if (email != null && password != null) {
      print(email);
      return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((AuthResult authResult) {
        firebaseUser = authResult.user;
        return firebaseUser;
      });
    } else {
      return Future.value(null);
    }
  }

  ///Store the email and password in shared preferences
  static Future saveEmailAndPassword(String email, String password) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('email', email);
    sharedPrefs.setString('password', password);
  }
}

final firestore_provider = CloudFirestoreProvider();
