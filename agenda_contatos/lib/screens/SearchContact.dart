import 'package:agenda_contatos/entity/contact.dart';
import 'package:agenda_contatos/screens/ContactList.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class SearchContact extends StatefulWidget {
  @override
  _SearchContactState createState() => _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController searchController = new TextEditingController();
  String search = "";
  bool canSearch = false;

  GlobalKey<FormState> editFormKey = new GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  MaskedTextController cepController = new MaskedTextController(mask: "00.000-000");
  TextEditingController phoneController = new TextEditingController();
  String phoneNumber = "";
  Contact contact = new Contact();

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          onChanged: () => setState(() => canSearch = formKey.currentState.validate()),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // search
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    labelText: "Busca",
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                  style: defaultColorTextStyle,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Digite sua busca (ID de contato ou nome)";
                    }

                    return null;
                  },
                ),
                !canSearch
                    ? Container(height: 0)
                    : StreamBuilder<QuerySnapshot>(
                        stream: int.tryParse(search) == null
                            ? FirebaseFirestore.instance
                                .collection("usuarios")
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection("contatos")
                                .withConverter(
                                  fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
                                  toFirestore: (contact, _) => contact.toJson(),
                                )
                                .where("nome", isGreaterThanOrEqualTo: search.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" "))
                                .where("nome", isLessThan: search.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ") + 'z')
                                .orderBy("nome")
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection("usuarios")
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection("contatos")
                                .withConverter(
                                  fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
                                  toFirestore: (contact, _) => contact.toJson(),
                                )
                                .where("id", isEqualTo: int.tryParse(search))
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("OH BOY!"),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data.size == 0) {
                            return Center(
                              child: Text("Sem resultados encontrados"),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.active) {
                            return Column(
                              children: snapshot.data.docs.map((contact) => ContactCard(contact: contact.data())).toList(),
                            );
                          }

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
