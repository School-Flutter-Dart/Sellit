import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sellit/resources/cloud_firestore_provider.dart';

import '../bloc/post_bloc.dart';

class PostEditPage extends StatefulWidget {
  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final priceController = TextEditingController();

  List<List<int>> imageBytes = List<List<int>>(4);

  Category currentCategory = Category.electronics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            DropdownButton<Category>(
                selectedItemBuilder: (context) {
                  return Category.values
                      .sublist(0, Category.values.length)
                      .map((category) => Container(
                            width: 96,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 18),
                                child: Text(categoryToString(currentCategory)),
                              ),
                            ),
                          ))
                      .toList();
                },
                value: currentCategory,
                style: TextStyle(color: Colors.white),
                items: [
                  for (var category in Category.values.sublist(0, Category.values.length))
                    DropdownMenuItem<Category>(value: category, child: Text(categoryToString(category), style: TextStyle(color: Colors.black)))
                ],
                onChanged: (Category category) {
                  setState(() {
                    currentCategory = category;
                  });
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.file_upload),
          onPressed: () {
            if (imageBytes.first == null) {
              showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return CupertinoAlertDialog(
                      title: Text('Must include at least one image'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
              return;
            }
            if (formKey.currentState.validate()) {
              String title = titleController.text;
              String content = contentController.text;
              double price = double.parse(priceController.text);
              postBloc.uploadPost(Post(
                  title: title,
                  content: content,
                  price: price,
                  category: currentCategory,
                  postId: Uuid().v4(),
                  postedDate: DateTime.now(),
                  postUserId: firestoreProvider.firebaseUser.uid,
                  postUserDisplayName: firestoreProvider.firebaseUser.displayName,
                  imageBytes: imageBytes));
              postBloc.fetchAllPosts();
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => DonePage()));
            }
          },
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [0, 1, 2, 3].map((index) {
                    if (imageBytes[index] == null) {
                      return Material(
                        child: Ink(
                          child: InkWell(
                            onTap: () => onAddPhotoTapped(index),
                            child: Center(
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Material(
                        child: Ink(
                          child: InkWell(
                            onTap: () => onAddPhotoTapped(index),
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.width / 2,
                                child: Image.memory(imageBytes[index], fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                    maxLengthEnforced: true,
                    maxLength: 50,
                    validator: (str) {
                      if (str.trim().isEmpty) {
                        return "Title cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(hintText: 'Content'),
                    maxLengthEnforced: true,
                    maxLength: 250,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  child: TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(hintText: 'Price'),
                    validator: (str) {
                      if (double.tryParse(str) == null) {
                        return "Invalid price";
                      } else
                        return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onAddPhotoTapped(int index) {
    getImageInBytes().then((bytes) {
      setState(() {
        imageBytes[index] = bytes;
      });
    });
  }

  Future getImageInBytes() async {
    var status = await Permission.camera.status;
    if (status.isUndetermined) {
      await [
        Permission.camera,
        Permission.photos,
      ].request();
    }
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    var bytes = await image.readAsBytes();

    return bytes;
  }
}

class DonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Transform.scale(
                scale: 30,
                child: FloatingActionButton(backgroundColor: Colors.blue, child: Container()),
              ),
              Center(
                child: Text('Success', style: TextStyle(color: Colors.white)),
              )
            ],
          )),
    );
  }
}
