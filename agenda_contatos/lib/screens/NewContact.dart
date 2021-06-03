import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:agenda_contatos/entity/contact.dart';
import 'package:agenda_contatos/screens/Main.dart';
import 'package:agenda_contatos/utils/calendar.dart';
import 'package:agenda_contatos/utils/error.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:googleapis/calendar/v3.dart' as googleCalendar;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:random_color/random_color.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  MaskedTextController cepController = MaskedTextController(mask: "00000-000");
  TextEditingController streetNameController = TextEditingController();
  TextEditingController streetNumberController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Map<String, dynamic> viaCEPData;
  PhoneNumber phone = PhoneNumber(isoCode: 'BR');
  String phoneNumber = "";
  ImagePicker picker = ImagePicker();
  File image;

  bool buttonEnabled = false;
  int nextID = 1;

  String getPath(Contact contact) {
    String hash = md5.convert(utf8.encode("${FirebaseAuth.instance.currentUser.uid}-${contact.id}")).toString();
    String path = hash.substring(0, 4).splitMapJoin("", onMatch: (c) => "${c.group(0)}/");
    return "images$path${contact.name.split(" ")[0].toLowerCase()}-$hash.jpg";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              GestureDetector(
                onTap: () async {
                  PickedFile pickedFile;
                  try {
                    pickedFile = await picker.getImage(source: ImageSource.camera);
                  } on PlatformException catch (e) {
                    if (e.code == "no_available_camera") {
                      pickedFile = await picker.getImage(source: ImageSource.gallery);
                    }
                  }

                  if (pickedFile != null) {
                    setState(() {
                      image = File(pickedFile.path);
                    });
                  }
                },
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
                    color: Colors.grey,
                    // TODO: inserir imagem custom
                    image: image == null
                        ? null
                        : DecorationImage(
                            alignment: Alignment.center,
                            fit: BoxFit.fill,
                            image: FileImage(image),
                          ),
                    shape: BoxShape.circle,
                  ),
                  height: 117.0,
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  width: 117.0,
                  child: image == null
                      ? Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        )
                      : Container(),
                ),
              ),
              Positioned(
                right: 0.0,
                bottom: 10.0,
                child: image == null
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            image = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0.0, 10.0),
                              ),
                            ],
                            color: Colors.grey[800],
                            shape: BoxShape.circle,
                          ),
                          height: 30.0,
                          width: 30.0,
                          child: Center(
                            child: Text("X", style: defaultTitleStyle),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
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
                // birthdate
                TextFormField(
                  // textAlign: TextAlign.center,
                  controller: dateController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.cake),
                    labelText: "Data de Aniversário",
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        dateController.value = TextEditingValue(text: DateFormat("dd/MMM/yyyy").format(picked).toUpperCase());
                      });
                    }
                  },
                  style: defaultColorTextStyle,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                ),
                // cep
                TextFormField(
                  controller: cepController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: "CEP",
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (value) async {
                    if (value.length == 9) {
                      Response response = await get(Uri.parse("https://viacep.com.br/ws/$value/json/"));
                      setState(() {
                        viaCEPData = json.decode(response.body);
                        streetNameController.value = TextEditingValue(text: viaCEPData["logradouro"]);
                        districtController.value = TextEditingValue(text: viaCEPData["bairro"]);
                        cityController.value = TextEditingValue(text: viaCEPData["localidade"]);
                        stateController.value = TextEditingValue(text: viaCEPData["uf"]);
                      });
                    }
                  },
                  style: defaultColorTextStyle,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Digite o CEP";
                    }

                    if (value.length < 9) {
                      return "CEP incompleto";
                    }

                    return null;
                  },
                ),
                Row(
                  children: [
                    // street name
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: streetNameController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.map),
                          labelText: "Rua",
                        ),
                        enabled: viaCEPData != null && viaCEPData["logradouro"] == "",
                        keyboardType: TextInputType.streetAddress,
                        style: defaultColorTextStyle,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Digite a rua";
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    // street number
                    Expanded(
                      child: TextFormField(
                        controller: streetNumberController,
                        decoration: InputDecoration(
                          labelText: "Nº",
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                        style: defaultColorTextStyle,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Digite o número";
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                // district
                TextFormField(
                  controller: districtController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.map),
                    labelText: "Bairro",
                  ),
                  enabled: viaCEPData != null && viaCEPData["bairro"] == "",
                  keyboardType: TextInputType.streetAddress,
                  style: defaultColorTextStyle,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Digite o bairro";
                    }

                    return null;
                  },
                ),
                Row(
                  children: [
                    // city
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.map),
                          labelText: "Cidade",
                        ),
                        enabled: viaCEPData != null && viaCEPData["localidade"] == "",
                        keyboardType: TextInputType.name,
                        style: defaultColorTextStyle,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Digite a cidade";
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    // state
                    Expanded(
                      child: TextFormField(
                        controller: stateController,
                        decoration: InputDecoration(
                          labelText: "Estado",
                        ),
                        enabled: viaCEPData != null && viaCEPData["uf"] == "",
                        keyboardType: TextInputType.name,
                        style: defaultColorTextStyle,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Digite o estado";
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
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
                                var streetName = streetNameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                                var streetNumber = streetNumberController.value.text.trim();
                                var district = districtController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                                var city = cityController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                                var state = stateController.value.text.trim().toUpperCase();
                                String address = "$streetName, $streetNumber - $district, $city - $state";

                                Contact contact = Contact(
                                  color: RandomColor().randomColor(colorSaturation: ColorSaturation.highSaturation, colorBrightness: ColorBrightness.primary).value,
                                  name: nameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" "),
                                  email: emailController.value.text,
                                  address: address,
                                  cep: cepController.value.text,
                                  phone: phoneNumber,
                                  birthdate: selectedDate,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );

                                DocumentReference reference = FirebaseFirestore.instance.collection("usuarios").doc(FirebaseAuth.instance.currentUser.uid);

                                await FirebaseFirestore.instance.runTransaction((transaction) async {
                                  DocumentSnapshot snapshot = await transaction.get(reference);

                                  setState(() {
                                    nextID = snapshot.get("ultimo_id") + 1;
                                  });

                                  contact.id = nextID;
                                  if (image != null) {
                                    String path = getPath(contact);
                                    TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(path).putFile(image);
                                    contact.imagePath = await taskSnapshot.ref.getDownloadURL();
                                  }

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

                                if (contact.birthdate != null) {
                                  googleCalendar.Event event = googleCalendar.Event();
                                  event.summary = "Aniverário de ${contact.name}";
                                  event.description = "Aniverário de ${contact.name}";

                                  googleCalendar.EventDateTime start = googleCalendar.EventDateTime();
                                  start.dateTime = contact.birthdate;
                                  start.timeZone = "UTC-3";
                                  event.start = start;

                                  googleCalendar.EventDateTime end = googleCalendar.EventDateTime();
                                  end.dateTime = contact.birthdate.add(Duration(days: 1));
                                  end.timeZone = "UTC-3";
                                  event.end = end;

                                  await calendar.events.insert(event, "primary").then((value) async {
                                    if (value.status == "confirmed") {
                                      contact.eventID = value.id;
                                      await reference.collection("contatos").doc("$nextID").update({"id_evento": contact.eventID});
                                      return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Evento criado",
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
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Não foi possível criar o evento!\nTente novamente mais tarde!",
                                              textAlign: TextAlign.center,
                                            ),
                                            contentPadding: EdgeInsets.only(top: 15.0),
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    primary: Colors.black,
                                                  ),
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
                                    }
                                  });
                                }
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
