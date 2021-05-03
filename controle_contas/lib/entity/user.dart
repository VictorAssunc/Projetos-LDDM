import 'package:intl/intl.dart';

class User {
  int id;
  String name, email, password;
  DateTime createdAt, updatedAt;
  User({this.id, this.name, this.email, this.password, this.createdAt, this.updatedAt});

  User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      createdAt: DateFormat("yyyy-MM-dd hh:mm:ss").parse(map['created_at']),
      updatedAt: DateFormat("yyyy-MM-dd hh:mm:ss").parse(map['updated_at']),
    );
  }

  @override
  String toString() {
    return "User: {"
        "id: ${this.id}, "
        "name: ${this.name}, "
        "email: ${this.email}, "
        "password: ${this.password}, "
        "createdAt: ${this.createdAt.toString()}, "
        "updatedAt: ${this.updatedAt.toString()}}";
  }
}
