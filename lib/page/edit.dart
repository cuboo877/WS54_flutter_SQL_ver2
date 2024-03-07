import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/service/sharedPref.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';
import '../constant/styleguide.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.passwordData});
  final PasswordData passwordData;
  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController name_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  bool obscure = false;
  @override
  void initState() {
    super.initState();
    name_controller = TextEditingController(text: widget.passwordData.name);
    url_controller = TextEditingController(text: widget.passwordData.url);
    login_controller = TextEditingController(text: widget.passwordData.login);
    password_controller =
        TextEditingController(text: widget.passwordData.password);
  }

  @override
  void dispose() {
    name_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  Future<PasswordData> generatePasswordDataAuto() async {
    UserData userdata = await getCurrentUserData();
    return PasswordData(
        id: widget.passwordData.id.toString(), //HACK
        userID: userdata.id.toString(), //HACK
        name: name_controller.text,
        url: url_controller.text,
        login: login_controller.text,
        password: password_controller.text,
        isFavorite: widget.passwordData.isFavorite);
  }

  Future<UserData> getCurrentUserData() async {
    UserData userData =
        await UserTB.getDataByAccount(await sharedPref.getLoggedAccount());
    return userData;
  }

  bool checkAllValid() {
    if (name_controller.text.trim().isNotEmpty &&
        url_controller.text.trim().isNotEmpty &&
        login_controller.text.trim().isNotEmpty &&
        password_controller.text.trim().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool hasLowerCase = true;
  bool hasUpperCase = true;
  bool hasNumbers = true;
  bool hasSymbols = true;
  String customChars = "";
  int length = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: StyleColor.darkBlue),
                  alignment: Alignment.topCenter,
                  child: setUpArea(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    favButton(),
                    const SizedBox(
                      width: 20,
                    ),
                    confirmEditPasswordButton(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                randomSettingButton()
              ],
            )),
        backgroundColor: StyleColor.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50), child: editPageAppBar()));
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            minimumSize: const Size(60, 60),
            elevation: 3,
            backgroundColor: widget.passwordData.isFavorite == 0
                ? StyleColor.white
                : StyleColor.red,
            shape: const CircleBorder(
                side: BorderSide(color: StyleColor.red, width: 2.0))),
        onPressed: () async {
          setState(() {
            widget.passwordData.isFavorite =
                (widget.passwordData.isFavorite == 1 ? 0 : 1);
          });
        },
        child: Icon(
          Icons.favorite,
          color: widget.passwordData.isFavorite == 1
              ? StyleColor.white
              : StyleColor.red,
          size: 30,
        ));
  }

  Widget confirmEditPasswordButton() {
    return TextButton(
        style: TextButton.styleFrom(
            minimumSize: const Size(60, 60),
            elevation: 3,
            backgroundColor: StyleColor.green,
            shape: const CircleBorder()),
        onPressed: () async {
          if (checkAllValid()) {
            String account = await sharedPref.getLoggedAccount();
            UserData userData = await UserTB.getDataByAccount(account);
            PasswordData passwordData = await generatePasswordDataAuto();

            await PasswordsTB.updatePasswordByPasswordID(
                passwordData, passwordData.id);
            print("edited password");
            if (mounted) {
              context.pushReplacement("/home", extra: userData);
            }
          } else {
            Utilities.showSnackBar(context, "輸入的資料不正確或不完整!",
                const Duration(seconds: 1), Duration.zero);
          }
        },
        child: const Icon(
          Icons.check,
          color: StyleColor.white,
          size: 30,
        ));
  }

  Widget randomSettingButton() {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10),
            backgroundColor: StyleColor.darkBlue,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      title: const Text("亂數生成設定"),
                      content: SizedBox(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("指定字元"),
                              TextFormField(
                                onChanged: (value) =>
                                    customChars = value.trim(),
                                decoration: const InputDecoration(
                                  hintText: "ex: cuboo",
                                ),
                              ),
                              CheckboxListTile(
                                  activeColor: StyleColor.darkBlue,
                                  title: const Text("包含小寫字母"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: hasLowerCase,
                                  onChanged: (value) {
                                    setState(() {
                                      hasLowerCase = !hasLowerCase;
                                    });
                                  }),
                              CheckboxListTile(
                                  activeColor: StyleColor.darkBlue,
                                  title: const Text("包含大寫字母"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: hasLowerCase,
                                  onChanged: (value) {
                                    setState(() {
                                      hasUpperCase = !hasUpperCase;
                                    });
                                  }),
                              CheckboxListTile(
                                  activeColor: StyleColor.darkBlue,
                                  title: const Text("包含數字"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: hasLowerCase,
                                  onChanged: (value) {
                                    setState(() {
                                      hasNumbers = !hasNumbers;
                                    });
                                  }),
                              CheckboxListTile(
                                  activeColor: StyleColor.darkBlue,
                                  title: const Text("包含符號"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: hasLowerCase,
                                  onChanged: (value) {
                                    setState(() {
                                      hasSymbols = !hasSymbols;
                                    });
                                  }),
                              const Divider(
                                color: StyleColor.lightgrey,
                              ),
                              const Text("指定長度"),
                              Row(
                                children: [
                                  Slider(
                                      max: 20,
                                      min: 1,
                                      divisions: 20,
                                      value: length.toDouble(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          length = newValue.toInt();
                                        });
                                      }),
                                  Text(length.toString())
                                ],
                              )
                            ]),
                      ));
                });
              });
        },
        child: const Text(
          "隨機密碼生成設定",
          style: TextStyle(color: StyleColor.white, fontSize: 20),
        ));
  }

  Widget setUpArea() {
    return Column(
      children: [
        inputTextForm(name_controller, "tag", const Icon(Icons.tag), "標籤"),
        inputTextForm(url_controller, "url", const Icon(Icons.link), "網址"),
        inputTextForm(login_controller, "login",
            const Icon(Icons.email_outlined), "登入帳號"),
        passwordInputTextForm(password_controller),
        const SizedBox(
          height: 35,
        )
      ],
    );
  }

  Widget inputTextForm(
      TextEditingController controller, String hint, Icon icon, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            title,
            style: const TextStyle(color: StyleColor.white, fontSize: 20),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45), color: StyleColor.white),
          width: 320,
          child: TextFormField(
            controller: controller,
            style: CustomFont.textFormInputText,
            decoration: InputDecoration(
                iconColor: StyleColor.lightgrey,
                prefixIcon: icon,
                hintText: hint,
                helperStyle: const TextStyle(color: StyleColor.lightgrey),
                labelStyle: CustomFont.textFormInputText,
                hintStyle: CustomFont.hintTextStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45),
                    borderSide: const BorderSide(
                        color: StyleColor.lightgrey, width: 1.5))),
          ),
        )
      ],
    );
  }

  Widget passwordInputTextForm(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "密碼",
            style: TextStyle(color: StyleColor.white, fontSize: 20),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45), color: StyleColor.white),
          width: 320,
          child: TextFormField(
            obscureText: obscure,
            controller: controller,
            style: CustomFont.textFormInputText,
            decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () async {
                          Object data = Utilities.randomPassword(
                              hasLowerCase,
                              hasUpperCase,
                              hasNumbers,
                              hasSymbols,
                              customChars,
                              length);
                          if (mounted) {
                            setState(() {
                              if (data != false) {
                                String result = data as String;
                                password_controller.text = result;
                              } else {
                                Utilities.showSnackBar(context, "指定字元不允許大於指定長度",
                                    const Duration(seconds: 1), Duration.zero);
                              }
                            });
                          }
                        },
                        icon: const Icon(Icons.casino)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility)),
                  ],
                ),
                iconColor: StyleColor.lightgrey,
                prefixIcon: const Icon(Icons.key),
                hintText: "password",
                helperStyle: const TextStyle(color: StyleColor.lightgrey),
                labelStyle: CustomFont.textFormInputText,
                hintStyle: CustomFont.hintTextStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45),
                    borderSide: const BorderSide(
                        color: StyleColor.lightgrey, width: 1.5))),
          ),
        )
      ],
    );
  }

  Widget editPageAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "修改您的密碼",
        style: TextStyle(color: StyleColor.black),
      ),
      backgroundColor: StyleColor.white,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: StyleColor.black,
        ),
        onPressed: () async {
          // ignore: use_build_context_synchronously
          UserData userData = await getCurrentUserData();
          // ignore: use_build_context_synchronously
          context.pushReplacement("/home", extra: userData);
        },
      ),
    );
  }
}
