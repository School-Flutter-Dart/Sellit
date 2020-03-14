import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Container(
              //I was thinking putting the logo on top of the title "Sellit" (it has enough space)
              child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 110.0, 15.0, 0.0),
                child: Text('Signup',
                    style: TextStyle(
                        fontSize: 90.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ],
          )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              decoration: InputDecoration(labelText: "EMAIL"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              decoration: InputDecoration(labelText: "PASSWORD"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              decoration: InputDecoration(labelText: "FULL NAME"),
            ),
          ),
          SizedBox(height: 50.0),
          Container(
              height: 50.0,
              width: 350.0,
              child: Material(
                  borderRadius: BorderRadius.circular(25.0),
                  shadowColor: Colors.blueAccent,
                  color: Colors.blue,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Text('CONFIRM',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  ))),
          SizedBox(height: 20.0), //height of empty space between fields
        ],
      ),
    );
  }
}
