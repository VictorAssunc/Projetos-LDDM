import 'dart:math';

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
  static final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    Widget lettersList = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/A.mp3");
                await player.play();
              },
              child: Text(
                "A",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/B.mp3");
                await player.play();
              },
              child: Text(
                "B",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/C.mp3");
                await player.play();
              },
              child: Text(
                "C",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/D.mp3");
                await player.play();
              },
              child: Text(
                "D",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/E.mp3");
                await player.play();
              },
              child: Text(
                "E",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/F.mp3");
                await player.play();
              },
              child: Text(
                "F",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/G.mp3");
                await player.play();
              },
              child: Text(
                "G",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/H.mp3");
                await player.play();
              },
              child: Text(
                "H",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/I.mp3");
                await player.play();
              },
              child: Text(
                "I",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/J.mp3");
                await player.play();
              },
              child: Text(
                "J",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/K.mp3");
                await player.play();
              },
              child: Text(
                "K",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/L.mp3");
                await player.play();
              },
              child: Text(
                "L",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/M.mp3");
                await player.play();
              },
              child: Text(
                "M",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/N.mp3");
                await player.play();
              },
              child: Text(
                "N",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/O.mp3");
                await player.play();
              },
              child: Text(
                "O",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/P.mp3");
                await player.play();
              },
              child: Text(
                "P",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/Q.mp3");
                await player.play();
              },
              child: Text(
                "Q",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/R.mp3");
                await player.play();
              },
              child: Text(
                "R",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/S.mp3");
                await player.play();
              },
              child: Text(
                "S",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/T.mp3");
                await player.play();
              },
              child: Text(
                "T",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/U.mp3");
                await player.play();
              },
              child: Text(
                "U",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/V.mp3");
                await player.play();
              },
              child: Text(
                "V",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/W.mp3");
                await player.play();
              },
              child: Text(
                "W",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/X.mp3");
                await player.play();
              },
              child: Text(
                "X",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/Y.mp3");
                await player.play();
              },
              child: Text(
                "Y",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/letters/Z.mp3");
                await player.play();
              },
              child: Text(
                "Z",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
    Widget numbersList = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/0.mp3");
                await player.play();
              },
              child: Text(
                "0",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/1.mp3");
                await player.play();
              },
              child: Text(
                "1",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/2.mp3");
                await player.play();
              },
              child: Text(
                "2",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/3.mp3");
                await player.play();
              },
              child: Text(
                "3",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/4.mp3");
                await player.play();
              },
              child: Text(
                "4",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/5.mp3");
                await player.play();
              },
              child: Text(
                "5",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/6.mp3");
                await player.play();
              },
              child: Text(
                "6",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/7.mp3");
                await player.play();
              },
              child: Text(
                "7",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/8.mp3");
                await player.play();
              },
              child: Text(
                "8",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/9.mp3");
                await player.play();
              },
              child: Text(
                "9",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/10.mp3");
                await player.play();
              },
              child: Text(
                "10",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/11.mp3");
                await player.play();
              },
              child: Text(
                "11",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/12.mp3");
                await player.play();
              },
              child: Text(
                "12",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/13.mp3");
                await player.play();
              },
              child: Text(
                "13",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/14.mp3");
                await player.play();
              },
              child: Text(
                "14",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/15.mp3");
                await player.play();
              },
              child: Text(
                "15",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/16.mp3");
                await player.play();
              },
              child: Text(
                "16",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/17.mp3");
                await player.play();
              },
              child: Text(
                "17",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/18.mp3");
                await player.play();
              },
              child: Text(
                "18",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/19.mp3");
                await player.play();
              },
              child: Text(
                "19",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await player.setAsset("assets/songs/numbers/20.mp3");
                await player.play();
              },
              child: Text(
                "20",
                style: TextStyle(
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Aprendendo " + (widget.type == LearnLetters ? "Letras" : "Números")),
      ),
      body: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Modak',
          fontSize: MediaQuery.of(context).size.width * .25,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .01),
          child: ListView(
            children: [
              widget.type == LearnLetters ? lettersList : numbersList,
            ],
          ),
        ),
      ),
    );
  }
}
