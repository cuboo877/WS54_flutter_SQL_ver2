import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';

class AccountTextForm extends StatefulWidget {
  AccountTextForm(
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
  State<StatefulWidget> createState() => _AccountTextFormState();
}

class _AccountTextFormState extends State<AccountTextForm> {
  bool isAccountValid = false;
  // late TextEditingController controller;
  // @override
  // void initState() {
  //   super.initState();
  //   controller = TextEditingController();
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: widget.controller,
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
            isAccountValid = false;
            widget.onChanged(isAccountValid);
            return "";
          } else if (value == null || value == "") {
            isAccountValid = false;
            widget.onChanged(isAccountValid);
            return "請輸入您的帳號";
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value)) {
            isAccountValid = false;
            widget.onChanged(isAccountValid);
            return "請輸入正確的信箱格式";
          }
          isAccountValid = true;
          widget.onChanged(isAccountValid);
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
