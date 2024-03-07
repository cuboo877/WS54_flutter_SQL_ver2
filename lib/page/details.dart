import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';
import 'package:ws54_flutter_sql_ver2/service/sharedPref.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/birthday_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/username_textform.dart';
import 'package:go_router/go_router.dart';

import '../service/auth.dart';
import '../service/sql_serivce.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isUserNameValid = false;
  bool isBirthDayValid = false;
  bool isLoading = false;
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;

  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
        absorbing: isLoading,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: StyleColor.white,
                  )),
              title: const Text(
                "即將完成註冊",
                style: TextStyle(
                    color: StyleColor.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: StyleColor.darkBlue,
            ),
            body: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "使用者名稱",
                          style: CustomFont.bigDarkBlueTitle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        UserNameTextForm(
                            controller: username_controller,
                            onUserNameChanged: (bool value) {
                              isUserNameValid = value;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "生日",
                          style: CustomFont.bigDarkBlueTitle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BirthDayTextForm(
                            controller: birthday_controller,
                            onBirthdayChanged: (bool value) {
                              isBirthDayValid = value;
                            }),
                        const SizedBox(
                          height: 40,
                        ),
                        startButton()
                      ]),
                )),
          ),
        ));
  }

  Widget startButton() {
    return SizedBox(
      width: 250,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)),
              alignment: Alignment.center,
              backgroundColor: StyleColor.darkBlue,
              padding: const EdgeInsets.all(10)),
          onPressed: () async {
            Utilities.showLoadingWindow(context, "註冊並開始", "Loading...");
            await Future.delayed(const Duration(milliseconds: 100));

            if (isBirthDayValid && isUserNameValid) {
              bool result = await Auth.registerProgram(username_controller.text,
                  birthday_controller.text, widget.account, widget.password);
              if (result == true) {
                await sharedPref.setLoggedAccount(widget.account);
                UserData userData =
                    await UserTB.getDataByAccount(widget.account);
                // ignore: use_build_context_synchronously
                context.pop();
                // FIXME : password tabl
                // ignore: use_build_context_synchronously
                context.go("/home", extra: userData);
                // ignore: use_build_context_synchronously
                Utilities.showSnackBar(
                    context,
                    "歡迎! 使用者:${username_controller.text}",
                    const Duration(seconds: 2),
                    Duration.zero);
              } else {
                // ignore: use_build_context_synchronously
                context.pop();
                // ignore: use_build_context_synchronously
                context.go("/register");
                // ignore: use_build_context_synchronously
                Utilities.showSnackBar(context, "出現了錯誤error",
                    const Duration(seconds: 1), Duration.zero);
              }
            } else {
              // ignore: use_build_context_synchronously
              context.pop();
              setState(() {});
            }

            setState(() {
              isLoading = false;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "開始",
                style: TextStyle(
                    color: StyleColor.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averta",
                    fontSize: 30),
              ),
              Icon(
                Icons.arrow_forward,
                color: StyleColor.white,
              )
            ],
          )),
    );
  }
}
