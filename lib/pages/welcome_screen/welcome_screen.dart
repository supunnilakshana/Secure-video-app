import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:securevideo/pages/sign_in_up/authcheckingscreen.dart';
import 'package:securevideo/pages/sign_in_up/signin.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);

    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthChecking()));
  }

  initScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print("Start");
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.2,
          ),
          Padding(
              padding: EdgeInsets.all(size.width * 0.1),
              child: Image.asset("assets/icons/appicon.png")),
          SizedBox(
            height: size.height * 0.2,
          ),
          Text(
            "Copyright 2022 © Cdrive",
            //Copyright 2021 © Dinesh Asian Mart
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ));
  }
}
