import 'package:agenda_contatos/screens/Login.dart';
import 'package:agenda_contatos/screens/Main.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting('pt_BR', null);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  runApp(AgendaContatos(firebase: firebase));
}

class AgendaContatos extends StatefulWidget {
  final Future<FirebaseApp> firebase;
  AgendaContatos({this.firebase});

  @override
  _AgendaContatosState createState() => _AgendaContatosState(firebase: firebase);
}

class _AgendaContatosState extends State<AgendaContatos> {
  final Future<FirebaseApp> firebase;
  _AgendaContatosState({this.firebase});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("OH BOY!"),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Agenda de Contatos',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.grey,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  primary: Colors.green,
                  textStyle: buttonStyle,
                ),
              ),
            ),
            home: FirebaseAuth.instance.currentUser != null ? Main() : Login(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
