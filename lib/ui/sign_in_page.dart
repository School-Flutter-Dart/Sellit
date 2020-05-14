import 'dart:core';

import 'package:flutter/material.dart';

import 'package:sellit/resources/cloud_firestore_provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailTextEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
              RaisedButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    String email = emailTextEditingController.text;
                    String password = passwordEditingController.text;
                    firestoreProvider.signInUser(email, password).then((value) {
                      if (value is Exception) {
                        print(value);
                      }
                      if (value != null) {
                        Navigator.pop(context);
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Signing in failed. Please check your email if you are the first time user.'),
                          action: SnackBarAction(label: 'Resend', onPressed: onResendTapped),
                        ));
                      }
                    }).catchError((Object err) {
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.toString())));
                    });
                  }
                },
                child: Text('Sign In'),
              ),
              RaisedButton(
                onPressed: () {
                  if (RegExp(r'^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(sjsu|sjsu2|SJSU|SJSU2)\.edu$')
                      .hasMatch(emailTextEditingController.text)) {
                    String email = emailTextEditingController.text;
                    firestoreProvider.forgetPassword(email);
                    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('An password reset link has been sent to your email address.')));
                  }
                },
                child: Text('Forgot Password'),
              ),
            ],
          )),
    );
  }

  void onResendTapped() {
    firestoreProvider.firebaseUser.sendEmailVerification();
  }
}
