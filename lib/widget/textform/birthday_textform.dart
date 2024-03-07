import 'package:flutter/material.dart';

import '../../constant/styleguide.dart';

class BirthDayTextForm extends StatelessWidget {
  BirthDayTextForm(
      {super.key,
      required this.controller,
      required this.onBirthdayChanged,
      this.isRead = false});

  final TextEditingController controller;
  final ValueChanged<bool> onBirthdayChanged;
  bool isRead;
  @override
  Widget build(BuildContext context) {
    bool isBirthdayValid = false;
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: controller,
        readOnly: isRead,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // onChanged: (value) {
        //   onBirthdayChanged(isBirthdayValid);
        // },
        onTap: () async {
          if (isRead == false) {
            DateTime? _picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100));
            if (_picked != null) {
              controller.text = _picked.toString().split(" ")[0];
              isBirthdayValid = true;
            } else {
              isBirthdayValid = false;
            }
            onBirthdayChanged(isBirthdayValid);
          }
        },
        validator: (value) {
          if (value == "" || value == null) {
            isBirthdayValid = false;
            onBirthdayChanged(isBirthdayValid);
            return "請輸入您的生日";
          }
          isBirthdayValid = true;
          onBirthdayChanged(isBirthdayValid);
          return null;
        },
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
            prefixIcon:
                const Icon(color: StyleColor.lightgrey, Icons.calendar_month),
            hintText: "YYYY-MM-DD",
            hintStyle: const TextStyle(color: StyleColor.lightgrey),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: StyleColor.lightgrey),
                borderRadius: BorderRadius.circular(45))),
      ),
    );
  }
}
