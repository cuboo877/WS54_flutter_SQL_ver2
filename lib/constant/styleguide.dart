import 'package:flutter/material.dart';

class StyleColor {
  static const white = Color(0xFFFFFFFF); // 主色彩-白色
  // 考慮到其他配色，我們可以添加如下：
  static const lightgrey = Color(0xFF5B5A5A); // 灰色，可以用在不需要強調的文字或背景
  static const soFkLightGrey = Color.fromARGB(255, 217, 215, 215); // 灰
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const darkBlue = Color.fromARGB(255, 46, 24, 166);
  static const red = Color.fromARGB(255, 224, 0, 0);
  static const green = Color.fromARGB(255, 29, 154, 7);
}

class CustomFont {
  static const bigDarkBlueTitle = TextStyle(
      fontFamily: "Averta",
      fontSize: 30,
      color: StyleColor.darkBlue,
      fontWeight: FontWeight.bold);

  static const smallBlackText = TextStyle(fontFamily: "Averta", fontSize: 13);

  static const textFormInputText = TextStyle(
    fontFamily: "Averta",
    fontSize: 15,
  );

  static const hintTextStyle = TextStyle(color: StyleColor.lightgrey);
}
