import 'package:app_educativo/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String __author__ = "Victor 'Texugo' Assunção";

void main() {
  runApp(AppEducativo());
}

class AppEducativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      title: 'App Educativo',
      theme: ThemeData(
        // primaryColor: Colors.orange[400],
        primarySwatch: Colors.orange,
      ),
    );
  }
}
