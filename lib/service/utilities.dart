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

  static Object randomPassword(bool hasLowerCase, bool hasUpperCase,
      bool hasNumbers, bool hasSymbols, String customChars, int length) {
    final random = Random();
    const lettersLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const lettersUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const numbers = "0123456789";
    const symbols = "!@#\$%^&*()_+[]{}:;<>?/";
    if (length > customChars.length) {
      int maxLength = length - customChars.length;
      String allChars = "";
      String result = "";
      StringBuffer buffer = StringBuffer();
      StringBuffer resultBuffer = StringBuffer();
      if (hasLowerCase) {
        buffer.write(lettersLowerCase);
      }
      if (hasUpperCase) {
        buffer.write(lettersUpperCase);
      }
      if (hasNumbers) {
        buffer.write(numbers);
      }
      if (hasSymbols) {
        buffer.write(symbols);
      }
      allChars = buffer.toString();

      for (int i = 0; i < maxLength; i++) {
        resultBuffer.write(allChars[random.nextInt(allChars.length)]);
      }
      result = resultBuffer.toString();
      int insertIndex = random.nextInt(result.length);
      result =
          "${result.substring(0, insertIndex)}${customChars}${result.substring(insertIndex, result.length)}";
      return result;
    } else {
      return false;
    }
  }

  static void showLoadingWindow(
      BuildContext context, String title, String content) {
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            alignment: Alignment.center,
            contentPadding: const EdgeInsets.all(30),
            title: Text(title),
            content: Row(children: [
              const CircularProgressIndicator(),
              const SizedBox(
                width: 20,
              ),
              Text(content)
            ]),
          );
        });
  }

  static void showSnackBar(BuildContext context, String content,
      Duration duration, Duration delay) async {
    ScaffoldMessenger.of(context).clearSnackBars();
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
