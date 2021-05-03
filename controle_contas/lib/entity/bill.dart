import 'package:intl/intl.dart';

class Bill {
  int id, status;
  String name, description;
  double value;
  DateTime expirationDate, createdAt, updatedAt;
  Bill({this.id, this.status, this.name, this.description, this.value, this.expirationDate, this.createdAt, this.updatedAt});

  static const PendingStatus = 0;
  static const ExpiredStatus = 1;
  static const PaidStatus = 2;

  Bill fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      status: map['status'],
      name: map['name'],
      description: map['description'],
      value: map['value'],
      expirationDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(map['expiration_date']),
      createdAt: DateFormat("yyyy-MM-dd hh:mm:ss").parse(map['created_at']),
      updatedAt: DateFormat("yyyy-MM-dd hh:mm:ss").parse(map['updated_at']),
    );
  }

  @override
  String toString() {
    return "Bill: {"
        "id: ${this.id}, "
        "status: ${this.status}, "
        "name: ${this.name}, "
        "description: ${this.description}, "
        "value: ${this.value}, "
        "expirationDate: ${DateFormat("dd/MM/yyyy").format(this.expirationDate)}, "
        "createdAt: ${this.createdAt.toString()}, "
        "updatedAt: ${this.updatedAt.toString()}}";
  }
}
