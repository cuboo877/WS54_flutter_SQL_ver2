import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/setup_password_textform.dart';

import '../../constant/styleguide.dart';

class ConfirmPasswordTextForm extends StatefulWidget {
  ConfirmPasswordTextForm(
      {super.key,
      required this.confirm_password_controller,
      required this.setup_password_controller});

  late TextEditingController confirm_password_controller;
  late TextEditingController setup_password_controller;
  @override
  State<StatefulWidget> createState() => _ConfirmPasswordTextFormState();

  bool getIsPasswordValid() {
    return _ConfirmPasswordTextFormState().isPasswordValid;
  }

  String getPassword() {
    return setup_password_controller.text;
  }
}

class _ConfirmPasswordTextFormState extends State<ConfirmPasswordTextForm> {
  bool isPasswordValid = false;
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
          obscureText: obscure,
          style: CustomFont.textFormInputText,
          controller: widget.confirm_password_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value != widget.getPassword()) {
              isPasswordValid = false;
              return "請重新確認密碼";
            } else if (value == null || value == "") {
              isPasswordValid = false;
              return "請輸入密碼";
            }
            isPasswordValid = true;
            return null;
          },
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.key,
                color: StyleColor.lightgrey,
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon:
                      Icon(obscure ? Icons.visibility_off : Icons.visibility)),
              hintText: "Password",
              helperStyle: const TextStyle(color: StyleColor.lightgrey),
              labelStyle: CustomFont.textFormInputText,
              hintStyle: CustomFont.hintTextStyle,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: StyleColor.lightgrey, width: 1.5)))),
    );
  }
}
