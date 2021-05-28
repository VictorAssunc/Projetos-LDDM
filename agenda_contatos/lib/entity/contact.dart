import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  int id, color;
  String name, email, address, cep, phone;
  DateTime createdAt, updatedAt;
  Contact({this.id, this.name, this.email, this.address, this.cep, this.phone, this.color, this.createdAt, this.updatedAt});

  Contact.from(Contact contact) {
    this.id = contact.id;
    this.name = contact.name;
    this.email = contact.email;
    this.address = contact.address;
    this.cep = contact.cep;
    this.phone = contact.phone;
    this.color = contact.color;
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
        "createdAt: ${this.createdAt.toString()}, "
        "updatedAt: ${this.updatedAt.toString()}}";
  }
}
