import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/service/auth.dart';
import 'package:ws54_flutter_sql_ver2/service/sharedPref.dart';
import '../constant/styleguide.dart';
import '../service/sql_serivce.dart';
import '../service/utilities.dart';

Widget logOutButton(BuildContext context, UserData userData) {
  return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
          height: 45,
          width: double.infinity,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)),
                  alignment: Alignment.center,
                  side: const BorderSide(width: 1.2, color: StyleColor.red),
                  backgroundColor: StyleColor.white),
              onPressed: () {
                Auth.logOutUserByUserData(userData);
                sharedPref.deleteLoggedAccount();
                context.go("/login");
                Utilities.showSnackBar(context, "已登出帳號",
                    const Duration(seconds: 1), Duration.zero);
              },
              child: const Text("登出",
                  style: TextStyle(color: StyleColor.red, fontSize: 23)))));
}
