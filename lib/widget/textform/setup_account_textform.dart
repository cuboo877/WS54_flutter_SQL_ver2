import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';

class SetUpAccountTextForm extends StatefulWidget {
  const SetUpAccountTextForm({super.key, required this.set_account_controller});
  final TextEditingController set_account_controller;

  @override
  State<StatefulWidget> createState() => _SetUpAccountTextFormState();
  bool getIsAccountValid() {
    return _SetUpAccountTextFormState().isAccountValid;
  }
}

class _SetUpAccountTextFormState extends State<SetUpAccountTextForm> {
  bool isAccountValid = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: widget.set_account_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value == "") {
            isAccountValid = false;
            return "請輸入您的帳號";
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value)) {
            isAccountValid = false;
            return "請輸入正確的信箱格式";
          }
          isAccountValid = true;
          return null;
        },
        style: CustomFont.textFormInputText,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.email,
              color: StyleColor.lightgrey,
            ),
            hintText: "Email",
            helperStyle: const TextStyle(color: StyleColor.lightgrey),
            labelStyle: CustomFont.textFormInputText,
            hintStyle: CustomFont.hintTextStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: StyleColor.lightgrey, width: 1.5))),
      ),
    );
  }
}
