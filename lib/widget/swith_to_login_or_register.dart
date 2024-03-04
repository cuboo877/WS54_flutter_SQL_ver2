import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';

import 'package:go_router/go_router.dart';

Widget loginToRegister(BuildContext context) {
  return Column(children: [
    const Text(
      "尚未擁有帳號?",
      style: CustomFont.smallBlackText,
    ),
    GestureDetector(
      onTap: () {
        context.push("/register");
      },
      child: const Text(
        "註冊",
        style: TextStyle(color: StyleColor.darkBlue, fontSize: 20),
      ),
    )
  ]);
}

Widget registerToLogin(BuildContext context) {
  return Column(children: [
    const Text(
      "已經擁有帳號?",
      style: CustomFont.smallBlackText,
    ),
    GestureDetector(
      onTap: () {
        context.push("/login");
      },
      child: const Text(
        "登入",
        style: TextStyle(color: StyleColor.darkBlue, fontSize: 20),
      ),
    )
  ]);
}
