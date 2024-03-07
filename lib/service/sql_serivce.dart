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
          'CREATE TABLE user_test (id TEXT PRIMARY KEY, username TEXT, birthday TEXT, account TEXT, password TEXT, activity INTEGER)');
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
        await userDB.query("user_test"); // get users table as list of map
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
    final maps = await userDB
        .query("user_test", where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> ud = maps.first;
    return UserData(
        id: ud["id"],
        username: ud["username"],
        birthday: ud["birthday"],
        account: ud["account"],
        password: ud["password"],
        activity: ud["activity"]);
  }

  static Future<UserData> getDataById(String id) async {
    final Database userDB = await _getDBConnect();
    final maps =
        await userDB.query("user_test", where: "id = ?", whereArgs: [id]);
    Map<String, dynamic> ud = maps.first;
    return UserData(
        id: ud["id"],
        username: ud["username"],
        birthday: ud["birthday"],
        account: ud["account"],
        password: ud["password"],
        activity: ud["activity"]);
  }

  static Future<Object> getDataByActivity() async {
    final Database userDB = await _getDBConnect();
    final maps =
        await userDB.query("user_test", where: "activity = ?", whereArgs: [1]);
    try {
      Map<String, dynamic> ud = maps.first;
      return UserData(
          id: ud["id"],
          username: ud["username"],
          birthday: ud["birthday"],
          account: ud["account"],
          password: ud["password"],
          activity: ud["activity"]);
    } catch (e) {
      print("we face some big problem");
      return false;
    }
  }

  static Future<bool> updateUser(UserData userData) async {
    try {
      final Database userDB = await _getDBConnect();
      await userDB.update("user_test", userData.toJson(),
          where: "id = ?",
          whereArgs: [userData.id],
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> addUser(UserData userData) async {
    final Database userDB = await _getDBConnect();
    await userDB.insert("user_test", userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> switchUserActivityByAccount(
      UserData userData, int activity) async {
    final Database userDB = await _getDBConnect();
    await userDB.update(
      "user_test",
      userData.toJson(),
      where: "id = ?",
      whereArgs: [userData.id],
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
  Map<String, dynamic> toJson() {
    // HACK // wtf is that?????????? toMap (X) toJson(O)
    // FIXME change to dynamic
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

  static Future<Database> initUserDatabase() async {
    passwordsDB = await openDatabase(
        join(await getDatabasesPath(),
            "ws2.db"), // HACK : should not create another database
        onCreate: (db, version) async {
      return await db.execute(
          'CREATE TABLE passwords (id TEXT PRIMARY KEY, userID TEXT, name TEXT, url TEXT, login TEXT, password TEXT, isFavorite INTEGER, FOREIGN KEY (userID) REFERENCES users (id))');
    }, version: 1);
    return passwordsDB!;
  }

  static Future<Database> _getDBConnect() async {
    if (passwordsDB != null) {
      return passwordsDB!;
    }
    return await initUserDatabase();
  }

  static Future<List<PasswordData>> getPasswords() async {
    final Database passwordsDB = await _getDBConnect(); // get Database userDB
    final List<Map<String, dynamic>> maps =
        await passwordsDB.query("passwords"); // get users table as list of map
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

  static Future<void> deletePasswordTableContent() async {
    final Database passwordsDB = await _getDBConnect();
    await passwordsDB.execute("DELETE FROM passwords");
  }

  static Future<Object> getPasswordsByUserID(String userID) async {
    try {
      final Database passwordDB = await _getDBConnect();
      final List<Map<String, dynamic>> maps = await passwordDB
          .query("passwords", where: "userID = ?", whereArgs: [userID]);
      return List.generate(maps.length, (index) {
        return PasswordData(
            id: maps[index]["id"].toString(), //HACK
            userID: maps[index]["userID"],
            name: maps[index]["name"],
            url: maps[index]["url"],
            login: maps[index]["login"],
            password: maps[index]["password"],
            isFavorite: maps[index]["isFavorite"]);
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> addPassword(PasswordData passwordData) async {
    final Database passwordsDB = await _getDBConnect();
    await passwordsDB.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deletePasswordByPasswordID(String passwordID) async {
    final Database passwordsDB = await _getDBConnect();
    await passwordsDB
        .delete("passwords", where: "id = ?", whereArgs: [passwordID]);
    print("deleted password ${passwordID}");
  }

  static Future<void> updatePasswordByPasswordID(
      PasswordData passwordData, String passwordID) async {
    final Database passwordsDB = await _getDBConnect();
    await passwordsDB.update(
      "passwords",
      passwordData.toJson(),
      where: "id = ?",
      whereArgs: [passwordID],
    );
  }

  static Future<void> switchPasswordFavoriteByPasswordID(
      PasswordData passwordData, int isFavorite) async {
    final Database passwordsDB = await _getDBConnect();
    passwordData.isFavorite = isFavorite;
    await passwordsDB.update(
      "passwords",
      passwordData.toJson(),
      where: "id = ?",
      whereArgs: [passwordData.id],
    );
    print("switch password fav: $isFavorite");
  }

  static Future<Object> getPasswordDataByUserIDAndCondition({
    // (O) : List<PasswordData> (X) : false
    required String userID,
    String? url,
    String? login,
    String? password,
    String? id,
    String? tag,
    int? isFav,
  }) async {
    try {
      final Database passwordsDB = await _getDBConnect();

      String whereCondition = 'userID = ?';
      List<dynamic> whereArgs = [userID];

      // 动态构建其他查询条件
      if (url != null && url.isNotEmpty) {
        whereCondition += ' AND url LIKE ?';
        whereArgs.add('%$url%');
      }
      if (login != null && login.isNotEmpty) {
        whereCondition += ' AND login LIKE ?';
        whereArgs.add('%$login%');
      }
      if (password != null && password.isNotEmpty) {
        whereCondition += ' AND password LIKE ?';
        whereArgs.add('%$password%');
      }
      if (id != null && id.isNotEmpty) {
        whereCondition += ' AND id = ?';
        whereArgs.add(id);
      }
      if (tag != null && tag.isNotEmpty) {
        whereCondition += ' AND name LIKE ?';
        whereArgs.add('%$tag%');
      }
      if (isFav != null) {
        whereCondition += ' AND isFavorite = ?';
        whereArgs.add(isFav);
      }

      // 执行查询
      final List<Map<String, dynamic>> result = await passwordsDB.query(
        'passwords',
        where: whereCondition,
        whereArgs: whereArgs,
      );

      List<PasswordData> nullableList = List.generate(result.length, (index) {
        return PasswordData(
            id: result[index]["id"]
                .toString(), //HACK : should change the type of id in the table
            userID: result[index]["userID"],
            name: result[index]["name"],
            url: result[index]["url"],
            login: result[index]["login"],
            password: result[index]["password"],
            isFavorite: result[index]["isFavorite"]);
      });
      if (nullableList.isNotEmpty && nullableList != null) {
        return nullableList;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id, // 115116486
      'userID': userID, // 654646464
      'name': name, // cuboo
      'url': url, // http://google.com
      'login': login, // cuboo@gmail.com
      'password': password, // usertestpassword
      'isFavorite': isFavorite // 0
    };
  }
}
