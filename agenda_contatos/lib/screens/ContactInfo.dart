import 'dart:convert';
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

class ContactInfo extends StatefulWidget {
  final Contact contact;
  ContactInfo({@required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState(contact: contact);
}

class _ContactInfoState extends State<ContactInfo> {
  Contact contact;
  _ContactInfoState({@required this.contact});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController dateController;
  MaskedTextController cepController;
  TextEditingController streetNameController;
  TextEditingController streetNumberController;
  TextEditingController districtController;
  TextEditingController cityController;
  TextEditingController stateController;
  TextEditingController phoneController;

  DateTime selectedDate;
  Map<String, dynamic> viaCEPData;
  PhoneNumber phone;
  String phoneNumber;
  ImagePicker picker = ImagePicker();
  File image;

  bool buttonEnabled = false;

  @override
  void initState() {
    List<String> fullAddress = this.contact.address.split(" - ");
    List<String> streetData = fullAddress.length > 0 ? fullAddress[0].split(", ") : ["", ""];
    List<String> districtAndCity = fullAddress.length > 1 ? fullAddress[1].split(", ") : ["", ""];

    String streetName = streetData[0];
    String streetNumber = streetData[1];
    String district = districtAndCity[0];
    String city = districtAndCity[1];
    String state = fullAddress.length > 2 ? fullAddress[2] : "";

    nameController = TextEditingController(text: this.contact.name);
    emailController = TextEditingController(text: this.contact.email);
    dateController = TextEditingController(text: this.contact.birthdate != null ? DateFormat("dd/MMM/yyyy").format(this.contact.birthdate).toUpperCase() : null);
    cepController = MaskedTextController(text: this.contact.cep, mask: "00000-000");
    streetNameController = TextEditingController(text: streetName);
    streetNumberController = TextEditingController(text: streetNumber);
    districtController = TextEditingController(text: district);
    cityController = TextEditingController(text: city);
    stateController = TextEditingController(text: state);
    phoneController = TextEditingController(text: this.contact.phone.substring(3));

    selectedDate = this.contact.birthdate;
    phoneNumber = this.contact.phone;
    phone = PhoneNumber(phoneNumber: this.contact.phone.substring(3), isoCode: PhoneNumber.getISO2CodeByPrefix(this.contact.phone.substring(0, 3)));
    super.initState();
  }

  String getPath(Contact contact) {
    String hash = md5.convert(utf8.encode("${FirebaseAuth.instance.currentUser.uid}-${contact.id}")).toString();
    String path = hash.substring(0, 4).splitMapJoin("", onMatch: (c) => "${c.group(0)}/");
    return "images$path${contact.name.split(" ")[0].toLowerCase()}-$hash.jpg";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Confirmar exclusão de contato?",
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: EdgeInsets.only(top: 15.0),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            primary: Colors.red,
                          ),
                          child: Text(
                            'Excluir',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("usuarios")
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection("contatos")
                                  .withConverter(
                                    fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
                                    toFirestore: (contact, _) => contact.toJson(),
                                  )
                                  .doc("${contact.id}")
                                  .delete();
                            } on FirebaseAuthException catch (e) {
                              return showError(context, e.code);
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Main(),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            primary: Colors.black,
                          ),
                          child: Text(
                            'Cancelar',
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
            },
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 35.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: !buttonEnabled
                  ? null
                  : () async {
                      try {
                        if (image != null) {
                          String path = getPath(contact);
                          TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(path).putFile(image);
                          contact.imagePath = await taskSnapshot.ref.getDownloadURL();
                        }

                        var streetName = streetNameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                        var streetNumber = streetNumberController.value.text.trim();
                        var district = districtController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                        var city = cityController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                        var state = stateController.value.text.trim().toUpperCase();
                        String address = "$streetName, $streetNumber - $district, $city - $state";

                        contact.name = nameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
                        contact.email = emailController.value.text;
                        contact.address = address;
                        contact.cep = cepController.value.text;
                        contact.phone = phoneNumber;
                        contact.birthdate = selectedDate;
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

                          await calendar.events.patch(event, "primary", contact.eventID);
                        } else {
                          await calendar.events.delete("primary", contact.eventID);
                        }
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
                        buttonEnabled = formKey.currentState.validate();
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
                      image: contact.imagePath == null && image == null
                          ? null
                          : DecorationImage(
                              alignment: Alignment.center,
                              fit: BoxFit.fill,
                              image: image == null ? NetworkImage(contact.imagePath) : FileImage(image),
                            ),
                      shape: BoxShape.circle,
                    ),
                    height: 117.0,
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    width: 117.0,
                    child: contact.imagePath == null
                        ? Center(
                            child: Text(
                              contact.name[0],
                              style: imageLetterStyle,
                              textScaleFactor: 1.5,
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
                              buttonEnabled = formKey.currentState.validate();
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
                ),
              ],
            ),
          ),
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: formKey,
            onChanged: () {
              var streetName = streetNameController.value.text.length > 0
                  ? streetNameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ")
                  : "";
              var streetNumber = streetNumberController.value.text.trim();
              var district = districtController.value.text.length > 0
                  ? districtController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ")
                  : "";
              var city = cityController.value.text.length > 0
                  ? cityController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ")
                  : "";
              var state = stateController.value.text.length > 0 ? stateController.value.text.trim().toUpperCase() : "";
              String address = "$streetName, $streetNumber - $district, $city - $state";

              Contact testContact = Contact.from(this.contact);
              testContact.name = nameController.value.text.trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1)}").join(" ");
              testContact.email = emailController.value.text;
              testContact.address = address;
              testContact.birthdate = selectedDate;
              testContact.cep = cepController.value.text;
              testContact.phone = phoneNumber;

              print("phoneNumber: $phoneNumber");
              print("phoneController: ${phoneController.value.text}");
              print("phone: $phone");
              print("this.contact: ${this.contact.phone}");
              print("testContact: ${testContact.phone}");

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
                        initialDate: selectedDate != null ? selectedDate : DateTime.now(),
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
                      streetNameController.clear();
                      districtController.clear();
                      cityController.clear();
                      stateController.clear();
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
                  // phone
                  InternationalPhoneNumberInput(
                    formatInput: false,
                    hintText: "Telefone",
                    initialValue: phone,
                    keyboardAction: TextInputAction.done,
                    keyboardType: TextInputType.numberWithOptions(),
                    onInputChanged: (value) {
                      print(value);
                      setState(() {
                        phoneNumber = value.phoneNumber;
                        phone = value;
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
