import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Learn extends StatefulWidget {
  Learn({Key key, this.type}) : super(key: key);
  final int type; // 0 - letras; 1 - números

  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  static const int LearnLetters = 0;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aprendendo " + (widget.type == LearnLetters ? "Letras" : "Números")),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Modak',
          color: Colors.green,
          fontSize: 80.0,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/1.mp3");
                          await player.play();
                        },
                        child: Text("1"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/2.mp3");
                          await player.play();
                        },
                        child: Text("2"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/3.mp3");
                          await player.play();
                        },
                        child: Text("3"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/4.mp3");
                          await player.play();
                        },
                        child: Text("4"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/5.mp3");
                          await player.play();
                        },
                        child: Text("5"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/6.mp3");
                          await player.play();
                        },
                        child: Text("6"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/7.mp3");
                          await player.play();
                        },
                        child: Text("7"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/8.mp3");
                          await player.play();
                        },
                        child: Text("8"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/9.mp3");
                          await player.play();
                        },
                        child: Text("9"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/10.mp3");
                          await player.play();
                        },
                        child: Text("10"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/11.mp3");
                          await player.play();
                        },
                        child: Text("11"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/12.mp3");
                          await player.play();
                        },
                        child: Text("12"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/13.mp3");
                          await player.play();
                        },
                        child: Text("13"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/14.mp3");
                          await player.play();
                        },
                        child: Text("14"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/15.mp3");
                          await player.play();
                        },
                        child: Text("15"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/16.mp3");
                          await player.play();
                        },
                        child: Text("16"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/17.mp3");
                          await player.play();
                        },
                        child: Text("17"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/18.mp3");
                          await player.play();
                        },
                        child: Text("18"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/19.mp3");
                          await player.play();
                        },
                        child: Text("19"),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.setAsset("assets/songs/numbers/20.mp3");
                          await player.play();
                        },
                        child: Text("20"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
