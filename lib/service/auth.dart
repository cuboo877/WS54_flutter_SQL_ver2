import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/service/sharedPref.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';
import '../widget/textform/account_textform.dart';
import '../widget/textform/password_textform.dart';

class Auth {
  static Future<bool> checkLogged() async {
    Object result = await UserTB.getDataByActivity();
    if (result != false) {
      print("(o) find activity userdata!");
      return true;
    } else {
      print("(x) there's not any activity userdata in db");
      return false;
    }
  }

  /// Check if the account has been registered
  /// just use getDataByAccount
  /// if getted, return true
  /// if not, it will throw a exception, and return false
  static Future<bool> checkRegistered(String account) async {
    try {
      await UserTB.getDataByAccount(account);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify that the login account exists
  /// 1. Get all the user data as a list.
  /// 2. Loop through the list and check if the parameters match the user data in the database.
  /// 3. If there is no match, return false.
  static Future<bool> loginVerifyProgram(
      String account, String password) async {
    List<UserData> users = await UserTB.getAllData();
    for (UserData userData in users) {
      print("${userData.account} vs $account");
      print("${userData.password} vs $password");
      if (userData.account == account && userData.password == password) {
        return true;
      }
    }
    return false;
  }

  static Future<Object> loginAuthentication(
      bool isAccountValid,
      bool isPasswordValid,
      bool doAuthWarning,
      String account,
      String password) async {
    print("$isAccountValid :AccountValid");
    print("$isPasswordValid :PasswordValid");
    if (isAccountValid == true && isPasswordValid == true) {
      if (await loginVerifyProgram(account, password)) {
        UserData userData = await UserTB.getDataByAccount(account);
        return userData;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> registerProgram(
      String username, String birthday, String account, String password) async {
    try {
      String id = Utilities.randomID().toString();
      int activity = 1;
      UserData userData = UserData(
          id: id,
          username: username,
          birthday: birthday,
          account: account,
          password: password,
          activity: activity);
      await UserTB.addUser(userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logOutUserByUserData(UserData userData) async {
    try {
      await UserTB.switchUserActivityByAccount(userData, 0);
      return true;
    } catch (e) {
      return false;
    }
  }
}
