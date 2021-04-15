// import 'package:audioplayers/audioplayers.dart';
import 'dart:core';

import 'package:app_educativo/screens/LearnScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int LearnLetters = 0;
  static const int LearnNumbers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Educativo"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Learn(type: LearnLetters))),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/lettersCover.png",
                        height: (MediaQuery.of(context).size.width * .8 * 9) / 16,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "LETRAS",
                        style: TextStyle(
                          height: 2.0,
                          fontFamily: 'Modak',
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Learn(type: LearnNumbers))),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/numbersCover.png",
                        height: (MediaQuery.of(context).size.width * .8 * 9) / 16,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "NÚMEROS",
                        style: TextStyle(
                          height: 2.0,
                          fontFamily: 'Modak',
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
