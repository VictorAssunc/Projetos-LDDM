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
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  MaskedTextController cepController = new MaskedTextController(mask: "00.000-000");
  TextEditingController phoneController = new TextEditingController();
  PhoneNumber phone = PhoneNumber();
  String phoneNumber = "";

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    nameController.value = TextEditingValue(text: contact.name);
    emailController.value = TextEditingValue(text: contact.email);
    addressController.value = TextEditingValue(text: contact.address);
    cepController.value = TextEditingValue(text: contact.cep);
    phoneNumber = contact.phone;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar contato",
          style: defaultColorTextStyle,
        ),
      ),
      body: ListView(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: formKey,
            onChanged: () async {
              await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
                phone = value;
              });
              setState(() => buttonEnabled = formKey.currentState.validate());
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
                    textInputAction: TextInputAction.done,
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
                    formatInput: true,
                    hintText: "Telefone",
                    initialValue: phone,
                    keyboardAction: TextInputAction.done,
                    keyboardType: TextInputType.numberWithOptions(),
                    maxLength: 13,
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

                      if (value.length < 12) {
                        return "Número de telefone incompleto";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  // botão criar
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: double.infinity,
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

                                showDialog(
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
                                            child: Text(
                                              'OK',
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.0)),
                        child: Text(
                          "Atualizar contato",
                          style: defaultColorTextStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
