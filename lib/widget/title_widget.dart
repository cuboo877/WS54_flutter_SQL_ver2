import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';

////////////////////////////////////////////////////
///This Widget is for loginpage and register page///
////////////////////////////////////////////////////
Widget loginAndRegisterTextTitle(String title) {
  return Container(
    alignment: Alignment.center,
    width: 500,
    height: 60,
    decoration: const BoxDecoration(
        color: StyleColor.darkBlue,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(80, 35),
            bottomRight: Radius.elliptical(80, 35))),
    child: Text(
      title,
      style: const TextStyle(
          color: StyleColor.white, fontWeight: FontWeight.bold, fontSize: 30),
    ),
  );
}
