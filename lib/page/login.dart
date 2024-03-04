import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/static_data.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';
import 'package:ws54_flutter_sql_ver2/service/auth.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/account_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/title_widget.dart';
import 'package:go_router/go_router.dart';
import '../widget/swith_to_login_or_register.dart';
import '../widget/textform/password_textform.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, this.initAccount, this.initPassword});
  String? initAccount;
  String? initPassword;
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isTermAgree = false;
  bool doAuthWarning = false;

  late TextEditingController account_controller;
  late TextEditingController password_controller;

  @override
  void initState() {
    super.initState();
    if (widget.initAccount != null) {
      account_controller = TextEditingController(text: widget.initAccount);
    } else {
      account_controller = TextEditingController();
    }

    if (widget.initPassword != null) {
      password_controller = TextEditingController(text: widget.initPassword);
    } else {
      password_controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
        absorbing: isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    loginAndRegisterTextTitle("登入"),
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
                    AccountTextForm(
                        doAuthWarning: doAuthWarning,
                        initValue: widget.initAccount,
                        controller: account_controller),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "密碼",
                      style: CustomFont.bigDarkBlueTitle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PasswordTextForm(
                        doAuthWarning: doAuthWarning,
                        initValue: widget.initPassword,
                        controller: password_controller),
                    const SizedBox(
                      height: 20,
                    ),
                    termOfUseRow(),
                    const SizedBox(
                      height: 20,
                    ),
                    loginButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    loginToRegister(context)
                  ]),
            ),
          ),
        ));
  }

  Widget loginButton() {
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
              Utilities.showLoadingWindow(context, "登入中", "Loaidng...");
              await Future.delayed(const Duration(milliseconds: 100));

              setState(() {
                isLoading = true;
              });

              // ignore: no_leading_underscores_for_local_identifiers
              Object _loginResult = await Auth.loginAuthentication(
                  doAuthWarning, password_controller, account_controller);
              if (_loginResult != false) {
                setState(() {
                  doAuthWarning = false;
                  context.pop();
                  context.go("/home", extra: _loginResult);
                  isLoading = false;
                  Utilities.showSnackBar(
                      context,
                      "登入成功!",
                      const Duration(seconds: 2),
                      const Duration(milliseconds: 500));
                  Utilities.showSnackBar(context, "目前使用者",
                      const Duration(seconds: 3), Duration.zero);
                });
              } else {
                setState(() {
                  doAuthWarning = true;
                  isLoading = false;
                  context.pop();
                  Utilities.showSnackBar(context, "登入失敗",
                      const Duration(seconds: 1), Duration.zero);
                });
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "登入",
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

  ///It's just like CheckboxListTile
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
