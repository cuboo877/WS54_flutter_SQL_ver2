import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';

class AccountTextForm extends StatefulWidget {
  AccountTextForm(
      {super.key,
      this.initValue,
      required this.doAuthWarning,
      required this.controller});
  bool doAuthWarning;
  String? initValue;
  final TextEditingController controller;
  @override
  State<StatefulWidget> createState() => _AccountTextFormState();

  bool getIsAccountValid() {
    return _AccountTextFormState().isAccountValid;
  }

  String getAccount() {
    return controller.text;
  }
}

class _AccountTextFormState extends State<AccountTextForm> {
  bool isAccountValid = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: () {
          setState(() {
            widget.controller.text = widget.initValue ?? "null";
            if (widget.doAuthWarning == true) {
              widget.doAuthWarning = false;
            }
          });
        },
        validator: (value) {
          if (widget.doAuthWarning) {
            isAccountValid = false;
            return "";
          } else if (value == null || value == "") {
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
