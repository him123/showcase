import 'dart:async';
import 'dart:io';

import 'package:sabon/model/menu.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sabon/model/address.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "sabon.db");

    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE favorite ("
          "id INTEGER PRIMARY KEY,"
          "product_id TEXT,"
          "branch_id TEXT,"
          "category_id TEXT,"
          "menu_title TEXT,"
          "menu_description TEXT,"
          "menu_image TEXT,"
          "menu_price TEXT,"
          "menu_veg_type TEXT,"
          "special_discount TEXT"
          ")");

      await db.execute("CREATE TABLE address ("
          "id INTEGER PRIMARY KEY,"
          "address_str TEXT,"
          "is_selected TEXT,"
          "type TEXT"
          ")");
    });
  }

  insertFavorite(Menu menu) async {
    print('Filter to be saved: ${menu.menu_title}');
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into "
        "favorite ("
        "product_id, "
        "branch_id, "
        "category_id, "
        "menu_title,"
        "menu_description, "
        "menu_image, "
        "menu_price, "
        "menu_veg_type, "
        "special_discount )"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          menu.id,
          menu.branch_id,
          menu.category_id,
          menu.menu_title,
          menu.menu_description,
          menu.menu_image,
          menu.menu_price,
          menu.menu_veg_type,
          menu.special_discount,
        ]);
    return raw;
  }

  insertAddress(Address address) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into "
        "address ("
        "address_str, "
        "is_selected, "
        "type )"
        " VALUES (?,?,?)",
        [
          address.address,
          'no',
          address.name,
        ]);

    print('address inserted');
    return raw;
  }

  updateAllAddressToNo() async {
    final db = await database;

    var raw = await db.rawUpdate('UPDATE address SET is_selected = "no"');

    print('Address ALL updated');
    return raw;
  }

  updateSelectionAddress(String id, String isSelected) async {
    final db = await database;

    var raw = await db.rawUpdate(
        'UPDATE address SET is_selected = "$isSelected" WHERE id = "$id"');
    print(' ======== $id Address updated');
    return raw;
  }

  Future<List<Menu>> getFavoriteMenu() async {
    print('getFavoriteMenu : =============');

    final db = await database;

    var res = await db.query("favorite");

    List<Menu> list =
        res.isNotEmpty ? res.map((c) => Menu.fromMap(c)).toList() : [];

    print('checkl list : ${list[0].menu_title}');

    return list;
  }

  Future<bool> checkIsFav(String id) async {

    final db = await database;
    var results = await db.rawQuery('SELECT * FROM favorite WHERE product_id = $id');

    if (results.length > 0) {
      print('================ prduct id $id is favorite');
      return true;
    }else{
      print('================ prduct id $id is NOT favorite');
      return false;
    }
  }


  Future<List<String>> getFavoriteMenuIds() async {
    print('getFavoriteMenu : =============');
    List<String> ids = [];
    final db = await database;

    var res = await db.query("favorite");

    List<Menu> list =
    res.isNotEmpty ? res.map((c) => Menu.fromMap(c)).toList() : [];

    print('checkl list : ${list[0].menu_title}');

    for(int i=0;i<list.length;i++){
      ids.add(list[i].id);
    }

    return ids;
  }


  Future<Address> getSelectedAddress() async {
    final db = await database;
    var results = await db.rawQuery('SELECT * FROM address WHERE is_selected = "yes"');

    if (results.length > 0) {
      return new Address.fromMap(results.first);
    }

    return null;
  }




  Future<List<Address>> getAddresses() async {
//    print('get addresses : =============');

    final db = await database;
    var res = await db.query("address");
    List<Address> list =
        res.isNotEmpty ? res.map((c) => Address.fromMap(c)).toList() : [];

    print('checkl list : ${list[0].address}');

    return list;
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete("address", where: 'id = ?', whereArgs: [id]);
  }

  deleteFavorite(String id) async {
    final db = await database;
    await db.delete("favorite", where: 'product_id = ?', whereArgs: [id]);
  }
}
