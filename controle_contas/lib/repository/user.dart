import 'package:controle_contas/entity/user.dart';
import 'package:controle_contas/error/error.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final Future<Database> db;
  UserRepository({this.db});

  Future<User> get(int id) async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> userMap = await db.rawQuery('''
      SELECT *
      FROM users
      WHERE id = ?
      LIMIT 1;
    ''', [id]);
    if (userMap.isEmpty) {
      return null;
    }

    return User().fromMap(userMap.first);
  }

  Future<User> getByEmail(String email) async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> userMap = await db.rawQuery('''
      SELECT *
      FROM users
      WHERE email = ?
      LIMIT 1;
    ''', [email]);
    if (userMap.isEmpty) {
      return null;
    }

    return User().fromMap(userMap.first);
  }

  Future<int> create(User user) async {
    final Database db = await this.db;
    final createUser = await getByEmail(user.email);
    if (createUser != null) {
      throw ErrEmailAlreadyRegistered;
    }

    return await db.rawInsert('''
      INSERT INTO users(name, email, password)
      VALUES (?, ?, ?);
    ''', [user.name, user.email, user.password]);
  }

  Future<int> update(User user) async {
    final Database db = await this.db;
    return await db.rawUpdate('''
      UPDATE users
      SET name = ?, email = ?, password = ?, updated_at = CURRENT_TIMESTAMP()
      WHERE id = ?;
    ''', [user.name, user.email, user.password, user.id]);
  }

  Future<User> auth(String email, password) async {
    final user = await getByEmail(email);
    if (user == null) {
      throw ErrInvalidEmail;
    }

    if (user.password != password) {
      throw ErrInvalidPassword;
    }

    return user;
  }
}
