import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icon/racha_conta_900.png",
                        height: (MediaQuery.of(context).size.width * .8 * 9) / 16,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "BATATATATATA",
                        style: TextStyle(height: 5.0, fontFamily: 'Balloons', fontStyle: FontStyle.italic, color: Colors.green),
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
