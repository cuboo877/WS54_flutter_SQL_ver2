import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';
import '../widget/textform/account_textform.dart';
import '../widget/textform/password_textform.dart';

class Auth {
  static Future<bool> checkLogged() async {
    try {
      await UserTB.getDataByActivity();
      return true;
    } catch (e) {
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
      if (userData.account == account && userData.password == password) {
        return true;
      }
    }
    return false;
  }

  static Future<Object> loginAuthentication(
      bool doAuthWarning,
      TextEditingController password_controller,
      TextEditingController account_controller) async {
    bool isAccountValid = AccountTextForm(
      controller: account_controller,
      doAuthWarning: doAuthWarning,
    ).getIsAccountValid();
    bool isPasswordValid = PasswordTextForm(
      doAuthWarning: doAuthWarning,
      controller: password_controller,
    ).getIsPasswordValid();

    if (isAccountValid == true && isPasswordValid == true) {
      String account = AccountTextForm(
        doAuthWarning: doAuthWarning,
        controller: account_controller,
      ).getAccount();
      String password = PasswordTextForm(
        doAuthWarning: doAuthWarning,
        controller: password_controller,
      ).getPassword();
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
}
