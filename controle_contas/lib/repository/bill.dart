import 'package:controle_contas/entity/bill.dart';
import 'package:sqflite/sqflite.dart';

class BillRepository {
  final Future<Database> db;
  BillRepository({this.db});

  Future<Bill> get(int id) async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> billMap = await db.rawQuery('''
      SELECT *
      FROM bills
      WHERE id = ?
      LIMIT 1;
    ''', [id]);
    if (billMap.isEmpty) {
      return null;
    }

    return Bill().fromMap(billMap.first);
  }

  Future<List<Bill>> getManyByUserID(int userID) async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> billsMaps = await db.rawQuery('''
      SELECT *
      FROM bills
      WHERE user_id = ?;
    ''', [userID]);
    if (billsMaps.isEmpty) {
      return null;
    }

    return List.generate(
      billsMaps.length,
      (index) {
        return Bill().fromMap(billsMaps[index]);
      },
    );
  }

  Future<int> create(Bill bill, int userID) async {
    final Database db = await this.db;
    return await db.rawInsert('''
      INSERT INTO bills(name, description, value, expiration_date, user_id)
        VALUES (?, ?, ?, ?, ?);
    ''', [bill.name, bill.description, bill.value, bill.expirationDate.toString(), userID]);
  }

  Future<int> update(Bill bill, int userID) async {
    final Database db = await this.db;
    return await db.rawUpdate('''
      UPDATE bills
      SET name = ?, description = ?, value = ?, expiration_date = ?, status = ?, updated_at = CURRENT_TIMESTAMP
      WHERE id = ? AND user_id = ?;
    ''', [bill.name, bill.description, bill.value, bill.expirationDate.toString(), bill.status, bill.id, userID]);
  }

  Future<int> updateStatus(Bill bill, int status, userID) async {
    final Database db = await this.db;
    return await db.rawUpdate('''
      UPDATE bills
      SET status = ?, updated_at = CURRENT_TIMESTAMP
      WHERE id = ? AND user_id = ?;
    ''', [status, bill.id, userID]);
  }

  Future<int> delete(Bill bill, int userID) async {
    final Database db = await this.db;
    return await db.rawDelete('''
      DELETE FROM bills
      WHERE id = ? AND user_id = ?;
    ''', [bill.id, userID]);
  }
}
