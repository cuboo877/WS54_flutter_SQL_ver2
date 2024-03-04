import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
Only one of the activities in the users table is 1,
which means that this account is currently logged in now
*/

class UserTB {
  static Database? userDB;

  static Future<Database> _initUserDatabase() async {
    userDB = await openDatabase(join(await getDatabasesPath(), "ws.db"),
        onCreate: (db, version) async {
      return await db.execute(
          'CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, account TEXT, password TEXT, activity INTEGER)');
    }, version: 1);
    return userDB!;
  }

  static Future<Database> _getDBConnect() async {
    if (userDB != null) {
      return userDB!;
    }
    return await _initUserDatabase();
  }

  static Future<List<UserData>> getAllData() async {
    final Database userDB = await _getDBConnect(); // get Database userDB
    final List<Map<String, dynamic>> maps =
        await userDB.query("users"); // get users table as list of map
    return List.generate(maps.length, (index) {
      // return list of UserData
      return UserData(
          // return data to list one by one
          id: maps[index]["id"],
          username: maps[index]["username"],
          birthday: maps[index]["birthday"],
          account: maps[index]["account"],
          password: maps[index]["password"],
          activity: maps[index]["activity"]);
    });
  }

  static Future<UserData> getDataByAccount(String account) async {
    final Database userDB = await _getDBConnect();
    final maps =
        await userDB.query("users", where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> ud = maps.first;
    return UserData(
        id: ud["id"],
        username: ud["username"],
        birthday: ud["birthday"],
        account: ud["account"],
        password: ud["password"],
        activity: ud["activity"]);
  }

  static Future<UserData> getDataByActivity() async {
    final Database userDB = await _getDBConnect();
    final maps =
        await userDB.query("users", where: "activity = ?", whereArgs: [1]);
    Map<String, dynamic> ud = maps.first;
    return UserData(
        id: ud["id"],
        username: ud["username"],
        birthday: ud["birthday"],
        account: ud["account"],
        password: ud["password"],
        activity: ud["activity"]);
  }

  static Future<void> addUser(UserData userData) async {
    final Database userDB = await _getDBConnect();
    await userDB.insert("users", userData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> switchUserActivityByAccount(
      UserData userData, int activity) async {
    final Database userDB = await _getDBConnect();
    await userDB.update(
      "users",
      userData.toMap(),
      where: "activity = ?",
      whereArgs: [activity],
    );
  }
}

class UserData {
  final String id;
  late String username;
  late String birthday;
  late String account;
  late String password;
  late int activity;
  UserData(
      {required this.id,
      required this.username,
      required this.birthday,
      required this.account,
      required this.password,
      required this.activity});
  Map<String, Object> toMap() {
    return {
      "id": id,
      "username": username,
      "birthday": birthday,
      "account": account,
      "password": password,
      "activity": activity
    };
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
class PasswordsTB {
  static Database? passwordsDB;

  static Future<Database> _initUserDatabase() async {
    passwordsDB = await openDatabase(join(await getDatabasesPath(), "ws.db"),
        onCreate: (db, version) async {
      return await db.execute(
          'CREATE TABLE passwords (id INTEGER PRIMARY KEY, userID TEXT, name TEXT, url TEXT, login TEXT, password TEXT, isFavorite INTEGER, FOREIGN KEY (userID) REFERENCES users (id))');
    }, version: 1);
    return passwordsDB!;
  }

  static Future<Database> _getDBConnect() async {
    if (passwordsDB != null) {
      return passwordsDB!;
    }
    return await _initUserDatabase();
  }

  static Future<List<PasswordData>> getPasswords() async {
    final Database passwordsDB = await _getDBConnect(); // get Database userDB
    final List<Map<String, dynamic>> maps =
        await passwordsDB.query("users"); // get users table as list of map
    return List.generate(maps.length, (index) {
      // return list of UserData
      return PasswordData(
          id: maps[index]["id"],
          userID: maps[index]["userID"],
          name: maps[index]["name"],
          url: maps[index]["url"],
          login: maps[index]["login"],
          password: maps[index]["password"],
          isFavorite: maps[index]["isFavorite"]);
    });
  }

  static Future<List<PasswordData>> getPasswordsByUserID(String userID) async {
    final Database db = await _getDBConnect();
    final List<Map<String, dynamic>> maps =
        await db.query("passwords", where: "userID = ?", whereArgs: [userID]);
    return List.generate(maps.length, (index) {
      return PasswordData(
          id: maps[index]["id"],
          userID: maps[index]["userID"],
          name: maps[index]["name"],
          url: maps[index]["url"],
          login: maps[index]["login"],
          password: maps[index]["password"],
          isFavorite: maps[index]["isFavorite"]);
    });
  }

  static Future<void> addPassword(PasswordData passwordData) async {
    final Database passwordsDB = await _getDBConnect();
    await passwordsDB.insert("passwords", passwordData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updatePasswordByUserID(
      PasswordData passwordData, String userID) async {
    final Database passwordsDB = await _getDBConnect();
    await passwordsDB.update(
      "passwords",
      passwordData.toMap(),
      where: "userID = ?",
      whereArgs: [userID],
    );
  }
}

class PasswordData {
  final String id;
  final String userID;
  late String name;
  late String url;
  late String login;
  late String password;
  late int isFavorite;

  PasswordData(
      {required this.id,
      required this.userID,
      required this.name,
      required this.url,
      required this.login,
      required this.password,
      required this.isFavorite});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'url': url,
      'login': login,
      'password': password,
      'isFavorite': isFavorite
    };
  }
}
