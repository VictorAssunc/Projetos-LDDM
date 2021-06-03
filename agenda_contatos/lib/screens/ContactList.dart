import 'package:agenda_contatos/entity/contact.dart';
import 'package:agenda_contatos/screens/ContactInfo.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("usuarios")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("contatos")
          .withConverter(
            fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
            toFirestore: (contact, _) => contact.toJson(),
          )
          .orderBy("nome")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("OH BOY!"),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text("Sem contatos cadastrados"),
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          return RefreshIndicator(
            onRefresh: () async => await this.refresh(),
            child: ListView(
              children: snapshot.data.docs.map((contact) => ContactCard(contact: contact.data())).toList(),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ContactCard extends StatefulWidget {
  final Contact contact;
  ContactCard({this.contact});

  @override
  _ContactCardState createState() => _ContactCardState(contact: this.contact);
}

class _ContactCardState extends State<ContactCard> {
  final Contact contact;
  _ContactCardState({this.contact});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MoneyMaskedTextController valueController = MoneyMaskedTextController(leftSymbol: "R\$ ", thousandSeparator: " ");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ContactInfo(contact: this.contact),
        ),
      ),
      child: Container(
        height: 120.0,
        margin: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 8.0,
        ),
        child: Stack(
          children: [
            // card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black26),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(5.0, 10.0),
                  ),
                ],
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
              height: 110.0,
              margin: EdgeInsets.only(left: 46.0),
              // content
              child: Container(
                margin: EdgeInsets.fromLTRB(39.0, 4.0, 0.0, 4.0),
                constraints: BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                      child: Text(
                        contact.name,
                        overflow: TextOverflow.ellipsis,
                        style: headerTextStyle,
                      ),
                    ),
                    Text(
                      "ID: ${contact.id}",
                      style: subHeaderTextStyle,
                    ),
                    Text(
                      contact.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subHeaderTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            // image
            Container(
              alignment: FractionalOffset.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(5.0, 10.0),
                  ),
                ],
                color: Color(contact.color).withOpacity(1.0),
                image: contact.imagePath == null
                    ? null
                    : DecorationImage(
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        image: NetworkImage(contact.imagePath),
                      ),
                shape: BoxShape.circle,
              ),
              height: 78.0,
              margin: EdgeInsets.symmetric(vertical: 16.0),
              width: 78.0,
              child: contact.imagePath == null
                  ? Center(
                      child: Text(
                        contact.name[0],
                        style: imageLetterStyle,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
