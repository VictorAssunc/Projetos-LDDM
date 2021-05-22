import 'package:agenda_contatos/screens/ContactList.dart';
import 'package:agenda_contatos/screens/Login.dart';
import 'package:agenda_contatos/screens/NewContact.dart';
import 'package:agenda_contatos/screens/SearchContact.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final List<Widget> screens = [
    NewContact(),
    ContactList(),
    SearchContact(),
  ];

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (screen) async {
          setState(() {
            index = screen;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "Novo Contato", tooltip: "Adicionar um novo contato"),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contatos", tooltip: "Lista de contatos"),
          BottomNavigationBarItem(icon: Icon(Icons.person_search), label: "Buscar Contatos", tooltip: "Buscar e editar contatos"),
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
              );
            },
          ),
        ],
        title: Text(
          "Contatos",
          style: defaultColorTextStyle,
        ),
      ),
      body: screens[index],
    );
  }
}
