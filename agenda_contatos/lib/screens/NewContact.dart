import 'package:agenda_contatos/entity/contact.dart';
import 'package:agenda_contatos/screens/Main.dart';
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
import 'package:random_color/random_color.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  MaskedTextController cepController = new MaskedTextController(mask: "00.000-000");
  TextEditingController phoneController = new TextEditingController();
  PhoneNumber phone = PhoneNumber(isoCode: 'BR');
  String phoneNumber = "";

  bool buttonEnabled = false;
  int nextID = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          onChanged: () => setState(() => buttonEnabled = formKey.currentState.validate()),
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
                                DocumentReference reference = FirebaseFirestore.instance.collection("usuarios").doc(FirebaseAuth.instance.currentUser.uid);

                                await FirebaseFirestore.instance.runTransaction((transaction) async {
                                  DocumentSnapshot snapshot = await transaction.get(reference);

                                  setState(() {
                                    nextID = snapshot.get("ultimo_id") + 1;
                                  });

                                  Contact contact = Contact(
                                    id: nextID,
                                    color: RandomColor().randomColor(colorSaturation: ColorSaturation.highSaturation, colorBrightness: ColorBrightness.primary).value,
                                    name: nameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" "),
                                    email: emailController.value.text,
                                    address: addressController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" "),
                                    cep: cepController.value.text,
                                    phone: phoneNumber,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  );

                                  transaction.set(
                                      reference
                                          .collection("contatos")
                                          .withConverter(
                                            fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
                                            toFirestore: (contact, _) => contact.toJson(),
                                          )
                                          .doc("$nextID"),
                                      contact);

                                  transaction.update(reference, {"ultimo_id": nextID});
                                });
                              } on FirebaseAuthException catch (e) {
                                return showError(context, e.code);
                              }

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Main(),
                                ),
                              );
                            },
                      child: Text(
                        "Criar contato",
                        style: buttonStyle,
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
    );
  }
}
