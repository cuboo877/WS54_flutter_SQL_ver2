import 'package:flutter/material.dart';

import '../../constant/styleguide.dart';

class PasswordTextForm extends StatefulWidget {
  PasswordTextForm(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.doAuthWarning,
      this.isRead = false});

  bool doAuthWarning;
  bool isRead;
  final ValueChanged<bool> onChanged;
  final TextEditingController controller;
  @override
  State<StatefulWidget> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  bool isPasswordValid = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
          obscureText: obscure,
          controller: widget.controller,
          style: CustomFont.textFormInputText,
          readOnly: widget.isRead,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () {
            setState(() {
              if (widget.doAuthWarning == true) {
                widget.doAuthWarning = false;
              }
            });
          },
          validator: (value) {
            if (widget.doAuthWarning) {
              isPasswordValid = false;
              widget.onChanged(isPasswordValid);
              return "錯誤的帳號或密碼";
            } else if (value == null || value == "") {
              isPasswordValid = false;
              widget.onChanged(isPasswordValid);
              return "請輸入您的密碼";
            }
            isPasswordValid = true;
            widget.onChanged(isPasswordValid);
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
