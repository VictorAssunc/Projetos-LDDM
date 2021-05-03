import 'package:controle_contas/repository/bill.dart';
import 'package:controle_contas/repository/user.dart';
import 'package:controle_contas/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting('pt_BR', null);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);

  final Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'controle_contas.db'),
    onCreate: (db, version) {
      db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      db.execute('''
        CREATE INDEX email_index ON users(email);
      ''');

      db.execute('''
        CREATE TABLE bills(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          value REAL NOT NULL,
          expiration_date TEXT NOT NULL,
          status INTEGER NOT NULL DEFAULT 0,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          user_id INTEGER NOT NULL,
          FOREIGN KEY(user_id) REFERENCES users(id)
        );
      ''');

      db.execute('''
        CREATE INDEX user_index ON bills(user_id);
      ''');
    },
    version: 1,
  );

  UserRepository userRepo = new UserRepository(db: db);
  BillRepository billRepo = new BillRepository(db: db);
  runApp(ControleContas(
    userRepository: userRepo,
    billRepository: billRepo,
  ));
}

class ControleContas extends StatelessWidget {
  final UserRepository userRepository;
  final BillRepository billRepository;
  ControleContas({this.userRepository, this.billRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Contas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Login(
        userRepository: this.userRepository,
        billRepository: this.billRepository,
      ),
    );
  }
}
