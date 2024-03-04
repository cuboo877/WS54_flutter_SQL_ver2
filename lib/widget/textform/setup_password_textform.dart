import 'package:flutter/material.dart';

import '../../constant/styleguide.dart';

class SetUpPasswordTextForm extends StatefulWidget {
  const SetUpPasswordTextForm(
      // ignore: non_constant_identifier_names
      {super.key,
      required this.setup_password_controller});

  // ignore: non_constant_identifier_names
  final TextEditingController setup_password_controller;

  @override
  State<StatefulWidget> createState() => _SetUpPasswordTextFormState();

  bool getIsPasswordValid() {
    return _SetUpPasswordTextFormState().isPasswordValid;
  }
}

class _SetUpPasswordTextFormState extends State<SetUpPasswordTextForm> {
  bool isPasswordValid = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: widget.setup_password_controller,
          obscureText: obscure,
          style: CustomFont.textFormInputText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value == "") {
              isPasswordValid = false;
              return "請輸入您的密碼";
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
