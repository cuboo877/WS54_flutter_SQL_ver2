import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';

class Utilities {
  static String randomID() {
    final random = Random();
    String result = "";
    for (int i = 0; i < 10; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static void showLoadingWindow(
      BuildContext context, String title, String content) {
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            contentPadding: const EdgeInsets.all(30),
            title: Text(title),
            content: Row(
                children: [const CircularProgressIndicator(), Text(content)]),
          );
        });
  }

  static void showSnackBar(BuildContext context, String content,
      Duration duration, Duration delay) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: StyleColor.darkBlue,
      content: Text(
        content,
        style: const TextStyle(color: StyleColor.white, fontSize: 20),
      ),
      duration: duration,
    ));
    await Future.delayed(delay);
  }
}
