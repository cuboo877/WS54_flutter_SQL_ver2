import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';
import 'package:ws54_flutter_sql_ver2/page/login.dart';
import 'package:ws54_flutter_sql_ver2/service/auth.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/account_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/confirm_password_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/password_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/setup_account_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/setup_password_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/title_widget.dart';
import 'package:go_router/go_router.dart';
import '../constant/static_data.dart';
import '../widget/swith_to_login_or_register.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isTermAgree = false;
  bool isLoading = false;
  late TextEditingController setup_account_controller;
  late TextEditingController setup_password_controller;
  late TextEditingController confirm_password_controller;

  @override
  void initState() {
    super.initState();
    setup_account_controller = TextEditingController();
    setup_password_controller = TextEditingController();
    confirm_password_controller = TextEditingController();
  }

  @override
  void dispose() {
    setup_account_controller.dispose();
    setup_password_controller.dispose();
    confirm_password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
        absorbing: isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                loginAndRegisterTextTitle("註冊"),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "帳號",
                  style: CustomFont.bigDarkBlueTitle,
                ),
                const SizedBox(
                  height: 20,
                ),
                SetUpAccountTextForm(
                  set_account_controller: setup_account_controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "設置密碼",
                  style: CustomFont.bigDarkBlueTitle,
                ),
                const SizedBox(
                  height: 20,
                ),
                SetUpPasswordTextForm(
                    setup_password_controller: setup_password_controller),
                const SizedBox(
                  height: 20,
                ),
                ConfirmPasswordTextForm(
                  confirm_password_controller: confirm_password_controller,
                  setup_password_controller: setup_password_controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                termOfUseRow(),
                const SizedBox(
                  height: 20,
                ),
                registerButton(),
                const SizedBox(
                  height: 20,
                ),
                registerToLogin(context)
              ],
            )),
          ),
        ));
  }

  Widget registerButton() {
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
            if (isTermAgree == false) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 200,
                      child: AlertDialog(
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45)),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                              style: const ButtonStyle(
                                  alignment: Alignment.center,
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(45)))),
                                  backgroundColor: MaterialStatePropertyAll(
                                      StyleColor.green)),
                              onPressed: () {
                                setState(() {
                                  isTermAgree = true;
                                  context.pop();
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "同意",
                                    style: TextStyle(
                                        color: StyleColor.white, fontSize: 20),
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: StyleColor.white,
                                    size: 18,
                                  )
                                ],
                              ))
                        ],
                        title: const Text("服務條款"),
                        content: SizedBox(
                          height: 370,
                          child: SingleChildScrollView(
                            child: Text(StaticData.term_of_use),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              Utilities.showLoadingWindow(context, "檢查是否曾經註冊", "Loading...");
              await Future.delayed(const Duration(milliseconds: 100));

              setState(() {
                isLoading = true;
              });
              // hasnt been registered before => details page
              bool result =
                  await Auth.checkRegistered(setup_account_controller.text);
              if (result == false && mounted) {
                context.goNamed("/login", extra: {
                  "account": setup_account_controller.text,
                  "password": setup_password_controller.text
                });
                Utilities.showSnackBar(context, "此帳號已註冊",
                    const Duration(seconds: 1), Duration.zero);
              } else {}
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "註冊",
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

  Widget termOfUseRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(
              () {
                isTermAgree = !isTermAgree;
              },
            );
          },
          icon: Icon(isTermAgree == false
              ? Icons.check_box_outline_blank
              : Icons.check_box),
          iconSize: 18,
        ),
        const Text("若登入後，即同意我們的 ", style: CustomFont.textFormInputText),
        GestureDetector(
          onTap: () {
            showDialog(
                context: (context),
                builder: (context) {
                  return SizedBox(
                    height: 200,
                    child: AlertDialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(
                            style: const ButtonStyle(
                                alignment: Alignment.center,
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(45)))),
                                backgroundColor:
                                    MaterialStatePropertyAll(StyleColor.red)),
                            onPressed: () {
                              context.pop();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "取消",
                                  style: TextStyle(
                                      color: StyleColor.white, fontSize: 20),
                                ),
                                Icon(
                                  Icons.close,
                                  color: StyleColor.white,
                                  size: 18,
                                )
                              ],
                            ))
                      ],
                      title: const Text("服務條款"),
                      content: SizedBox(
                        height: 370,
                        child: SingleChildScrollView(
                          child: Text(StaticData.term_of_use),
                        ),
                      ),
                    ),
                  );
                });
          },
          child: const Text("服務條款",
              style: TextStyle(color: StyleColor.darkBlue, fontSize: 20)),
        )
      ],
    );
  }
}
