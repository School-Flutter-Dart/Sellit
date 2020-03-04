import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../bloc/post_bloc.dart';

class PostEditPage extends StatefulWidget {
  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          String title = titleController.text;
          String content = contentController.text;
          double price = double.parse(priceController.text);
          postBloc.uploadPost(Post(title: title, content: content, price: price, postId: Uuid().v4()));
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>DonePage()));
        },
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            child: TextField(
              controller: contentController,
              decoration: InputDecoration(hintText: 'Content'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            child: TextField(
              controller: priceController,
              decoration: InputDecoration(hintText: 'Price'),
            ),
          ),
        ],
      ),
    );
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
