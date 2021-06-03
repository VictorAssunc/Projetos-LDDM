import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  int id, color;
  String name, email, address, cep, phone, imagePath, eventID;
  File image;
  DateTime birthdate, createdAt, updatedAt;
  Contact({this.id, this.name, this.email, this.address, this.cep, this.phone, this.color, this.imagePath, this.eventID, this.birthdate, this.createdAt, this.updatedAt});

  Contact.from(Contact contact) {
    this.id = contact.id;
    this.name = contact.name;
    this.email = contact.email;
    this.address = contact.address;
    this.cep = contact.cep;
    this.phone = contact.phone;
    this.color = contact.color;
    this.imagePath = contact.imagePath;
    this.eventID = contact.eventID;
    this.birthdate = contact.birthdate;
    this.createdAt = contact.createdAt;
    this.updatedAt = contact.updatedAt;
  }

  bool isEqual(Contact contact) {
    return this.id == contact.id &&
        this.name == contact.name &&
        this.email == contact.email &&
        this.address == contact.address &&
        this.cep == contact.cep &&
        this.phone == contact.phone &&
        this.color == contact.color &&
        this.image == contact.image &&
        this.birthdate == contact.birthdate &&
        this.createdAt == contact.createdAt &&
        this.updatedAt == contact.updatedAt;
  }

  Contact.fromJson(Map<String, Object> json)
      : this(
          id: json["id"] as int,
          color: json["cor"] as int,
          name: json["nome"] as String,
          email: json["email"] as String,
          address: json["endereco"] as String,
          cep: json["cep"] as String,
          phone: json["telefone"] as String,
          imagePath: json["imagem"] as String,
          eventID: json["id_evento"] as String,
          birthdate: json["aniversario"] != null ? (json["aniversario"] as Timestamp).toDate() : null,
          createdAt: (json["criado_em"] as Timestamp).toDate(),
          updatedAt: (json["atualizado_em"] as Timestamp).toDate(),
        );

  Map<String, Object> toJson() {
    return {
      "id": id,
      "cor": color,
      "nome": name,
      "email": email,
      "endereco": address,
      "cep": cep,
      "telefone": phone,
      "imagem": imagePath,
      "id_evento": eventID,
      "aniversario": birthdate != null ? Timestamp.fromDate(birthdate) : null,
      "criado_em": Timestamp.fromDate(createdAt),
      "atualizado_em": Timestamp.fromDate(updatedAt),
    };
  }

  @override
  String toString() {
    return "Contact: {"
        "id: ${this.id}, "
        "color: ${this.color}, "
        "name: ${this.name}, "
        "email: ${this.email}, "
        "address: ${this.address}, "
        "cep: ${this.cep}, "
        "phone: ${this.phone}, "
        "imagePath: ${this.imagePath}, "
        "eventID: ${this.eventID}, "
        "image: ${this.image}, "
        "birthdate: ${this.birthdate.toString()}, "
        "createdAt: ${this.createdAt.toString()}, "
        "updatedAt: ${this.updatedAt.toString()}}";
  }
}
