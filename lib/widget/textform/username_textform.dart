import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/styleguide.dart';

class UserNameTextForm extends StatelessWidget {
  UserNameTextForm(
      {super.key,
      required this.controller,
      required this.onUserNameChanged,
      this.isRead = false});
  bool isRead;
  final TextEditingController controller;
  final ValueChanged<bool> onUserNameChanged;
  @override
  Widget build(BuildContext context) {
    bool isUserNameValid = false;
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // onChanged: (value) {
        //   onUserNameChanged(isUserNameValid);
        // },
        readOnly: isRead,
        validator: (value) {
          if (value == null || value == "" || value.trim().isEmpty) {
            isUserNameValid = false;
            onUserNameChanged(isUserNameValid);
            return "請輸入名稱";
          }
          isUserNameValid = true;
          onUserNameChanged(isUserNameValid);
          return null;
        },
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
            prefixIcon: const Icon(color: StyleColor.lightgrey, Icons.person),
            hintText: "User Name",
            hintStyle: const TextStyle(color: StyleColor.lightgrey),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: StyleColor.lightgrey),
                borderRadius: BorderRadius.circular(45))),
      ),
    );
  }
}
