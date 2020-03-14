import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                child: Text('Sell',
                    style: TextStyle(
                        fontSize: 90.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(160.0, 110.0, 50.0, 0.0),
                child: Text('it',
                    style: TextStyle(
                        fontSize: 90.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              )
            ],
          )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              decoration: InputDecoration(labelText: "Username"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              decoration: InputDecoration(labelText: "Password"),
            ),
          ),
          SizedBox(height: 40.0),
          Container(
              height: 75.0,
              width: 350.0,
              child: Material(
                  borderRadius: BorderRadius.circular(25.0),
                  shadowColor: Colors.blueAccent,
                  color: Colors.blue,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Text('LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  ))),
          SizedBox(height: 20.0), //height of empty space between fields
          Container(
            height: 50.0,
            width: 350.0,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1.0),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text("SIGN UP",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )))
                  ],
                )),
          ),
          SizedBox(height: 45.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Forgot password?",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {},
                child: Text(
                  "Click here!",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
