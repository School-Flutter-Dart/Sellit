import 'dart:core';

import 'package:flutter/material.dart';

import 'package:sellit/resources/cloud_firestore_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final passwordVerificationEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordEditingController.dispose();
    passwordVerificationEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: TextFormField(
                  controller: emailTextEditingController,
                  decoration: InputDecoration(hintText: 'Enter your SJSU email address', labelText: 'SJSU email'),
                  autovalidate: false,
                  autocorrect: false,
                  validator: (String value) {
                    if (RegExp(r'^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(sjsu|sjsu2|SJSU|SJSU2)\.edu$').hasMatch(value)) {
                      return null;
                    } else {
                      return "Invalid SJSU email";
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordEditingController,
                  decoration: InputDecoration(hintText: 'Enter your password', labelText: 'Password'),
                  autovalidate: true,
                  validator: (String value) {
                    if (value.length >= 8) {
                      return null;
                    } else {
                      return "Password must be at least 8 characters";
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordVerificationEditingController,
                  decoration: InputDecoration(hintText: 'Re-enter Password'),
                  autovalidate: true,
                  validator: (String value) {
                    if (value == passwordEditingController.text) {
                      return null;
                    } else {
                      return 'Password not matched';
                    }
                  },
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    String email = emailTextEditingController.text;
                    String password = passwordEditingController.text;
                    firestore_provider.registerNewUser(email, password).whenComplete((){
                      //firestore_provider.signInUser(email, password);
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Submit'),
              )
            ],
          )),
    );
  }
}
