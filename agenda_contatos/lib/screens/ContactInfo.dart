import 'package:agenda_contatos/entity/contact.dart';
import 'package:agenda_contatos/utils/error.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ContactInfo extends StatefulWidget {
  final Contact contact;
  ContactInfo({@required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState(contact: contact);
}

class _ContactInfoState extends State<ContactInfo> {
  final Contact contact;
  _ContactInfoState({@required this.contact});

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController addressController;
  MaskedTextController cepController;
  TextEditingController phoneController;
  PhoneNumber phone;
  String phoneNumber;

  bool buttonEnabled = false;

  @override
  void initState() {
    nameController = TextEditingController(text: this.contact.name);
    emailController = TextEditingController(text: this.contact.email);
    addressController = TextEditingController(text: this.contact.address);
    cepController = MaskedTextController(text: this.contact.cep, mask: "00.000-000");
    phoneController = TextEditingController(text: this.contact.phone.substring(3));
    phoneNumber = this.contact.phone;
    phone = PhoneNumber(phoneNumber: this.contact.phone.substring(3), isoCode: PhoneNumber.getISO2CodeByPrefix(this.contact.phone.substring(0, 3)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: !buttonEnabled
                  ? null
                  : () async {
                      try {
                        contact.name = nameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                        contact.email = emailController.value.text;
                        contact.address = addressController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                        contact.cep = cepController.value.text;
                        contact.phone = phoneNumber;
                        contact.updatedAt = DateTime.now();
                        await FirebaseFirestore.instance
                            .collection("usuarios")
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection("contatos")
                            .withConverter(
                              fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
                              toFirestore: (contact, _) => contact.toJson(),
                            )
                            .doc("${contact.id}")
                            .set(contact);
                      } on FirebaseAuthException catch (e) {
                        return showError(context, e.code);
                      }

                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Contato atualizado",
                              textAlign: TextAlign.center,
                            ),
                            contentPadding: EdgeInsets.only(top: 15.0),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    primary: Colors.green,
                                  ),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
              child: Text(
                "Salvar",
                style: actionButtonStyle,
              ),
            ),
          ),
        ],
        leading: CloseButton(color: Colors.white),
        title: Text(
          "Editar contato",
          style: defaultTitleStyle,
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              alignment: FractionalOffset.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
                color: Color(contact.color).withOpacity(1.0),
                // TODO: inserir imagem custom
                // image: DecorationImage(
                //   alignment: Alignment.center,
                //   fit: BoxFit.fill,
                //   image: NetworkImage("https://thispersondoesnotexist.com/image"),
                // ),
                shape: BoxShape.circle,
              ),
              height: 117.0,
              margin: EdgeInsets.symmetric(vertical: 16.0),
              width: 117.0,
              child: Center(
                child: Text(
                  contact.name[0],
                  style: imageLetterStyle,
                  textScaleFactor: 1.5,
                ),
              ),
            ),
          ),
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: formKey,
            onChanged: () {
              Contact testContact = Contact.from(this.contact);
              testContact.name = nameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
              testContact.email = emailController.value.text;
              testContact.address = addressController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
              testContact.cep = cepController.value.text;
              testContact.phone = phoneNumber;

              setState(() {
                buttonEnabled = formKey.currentState.validate() && !testContact.isEqual(this.contact);
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // name
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Nome",
                    ),
                    keyboardType: TextInputType.name,
                    style: defaultColorTextStyle,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Digite o nome";
                      }

                      return null;
                    },
                  ),
                  // email
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: defaultColorTextStyle,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Digite o email";
                      }

                      if (!EmailValidator.validate(value)) {
                        return "Email inválido";
                      }

                      return null;
                    },
                  ),
                  // address
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_on),
                      labelText: "Endereço",
                    ),
                    keyboardType: TextInputType.streetAddress,
                    style: defaultColorTextStyle,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Digite o endereço";
                      }

                      return null;
                    },
                  ),
                  // cep
                  TextFormField(
                    controller: cepController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.map),
                      labelText: "CEP",
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    style: defaultColorTextStyle,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Digite o CEP";
                      }

                      if (value.length < 10) {
                        return "CEP incompleto";
                      }

                      return null;
                    },
                  ),
                  // phone
                  InternationalPhoneNumberInput(
                    formatInput: false,
                    hintText: "Telefone",
                    initialValue: phone,
                    keyboardAction: TextInputAction.done,
                    keyboardType: TextInputType.numberWithOptions(),
                    onInputChanged: (value) {
                      setState(() {
                        phoneNumber = value.phoneNumber;
                      });
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      showFlags: true,
                      setSelectorButtonAsPrefixIcon: true,
                    ),
                    selectorTextStyle: defaultColorTextStyle,
                    textFieldController: phoneController,
                    textStyle: defaultColorTextStyle,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Digite o número de telefone";
                      }

                      if (value.length < 10) {
                        return "Número de telefone incompleto";
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
