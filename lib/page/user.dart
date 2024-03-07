import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/account_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/birthday_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/password_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/setup_account_textform.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/username_textform.dart';

import '../service/sql_serivce.dart';
import '../widget/logout_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userData});
  final UserData userData;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController set_account_controller;
  late TextEditingController set_username_controller;
  late TextEditingController set_password_controller;
  late TextEditingController set_birthday_controller;
  bool isUserNameValid = false;
  bool isPasswordValid = false;
  bool isAccountValid = false;
  bool isBirthdayValid = false;
  bool isRead = true;

  bool checkIsAllValid() {
    return isAccountValid &&
        isPasswordValid &&
        isUserNameValid &&
        isBirthdayValid;
  }

  void switchIsRead() {
    setState(() {
      isRead = !isRead;
    });
  }

  @override
  void initState() {
    super.initState();
    set_account_controller =
        TextEditingController(text: widget.userData.account);
    set_username_controller =
        TextEditingController(text: widget.userData.username);
    set_password_controller =
        TextEditingController(text: widget.userData.password);
    set_birthday_controller =
        TextEditingController(text: widget.userData.birthday);
  }

  @override
  void dispose() {
    set_account_controller.dispose();
    set_username_controller.dispose();
    set_password_controller.dispose();
    set_birthday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: StyleColor.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: userPageAppBar(),
        ),
        body: Column(children: [
          dataColumn(),
          logOutButton(context, widget.userData),
        ]),
      ),
    );
  }

  Widget dataColumn() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          "使用者名稱",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        UserNameTextForm(
            isRead: isRead,
            controller: set_username_controller,
            onUserNameChanged: (value) {
              isUserNameValid = value;
            }),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "帳號",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        AccountTextForm(
          isRead: isRead,
          controller: set_account_controller,
          doAuthWarning: false,
          onChanged: (value) {
            isAccountValid = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "密碼",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        PasswordTextForm(
            isRead: isRead,
            controller: set_password_controller,
            onChanged: (value) {
              isPasswordValid = value;
            },
            doAuthWarning: false),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "生日",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        BirthDayTextForm(
          isRead: isRead,
          controller: set_birthday_controller,
          onBirthdayChanged: (value) {
            isBirthdayValid = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "ID (不可編輯)",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 320,
          child: TextFormField(
            initialValue: widget.userData.id,
            readOnly: true,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                prefixIcon:
                    const Icon(color: StyleColor.lightgrey, Icons.person),
                hintText: "User ID",
                hintStyle: const TextStyle(color: StyleColor.lightgrey),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: StyleColor.lightgrey),
                    borderRadius: BorderRadius.circular(45))),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        startEditButton(),
      ],
    );
  }

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////x/////////
  Widget startEditButton() {
    return FloatingActionButton(
      heroTag: "start edit button tag",
      backgroundColor: isRead ? StyleColor.green : StyleColor.red,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(45)),
      onPressed: () {
        if (isRead == false) {
          showDialog(
              context: context,
              builder: (context) => comfirmSubmitAlertDialog());
        } else {
          switchIsRead();
        }
      },
      child: isRead ? const Icon(Icons.edit) : const Icon(Icons.upload),
    );
  }

  Widget comfirmSubmitAlertDialog() {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(45)),
      title: const Text(
        "是否確認編輯後的資料",
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("使用者名稱"),
        Text(set_username_controller.text),
        const Divider(
          color: StyleColor.lightgrey,
        ),
        const Text("帳號"),
        Text(set_account_controller.text),
        const Divider(
          color: StyleColor.lightgrey,
        ),
        const Text("密碼"),
        Text(set_password_controller.text),
        const Divider(
          color: StyleColor.lightgrey,
        ),
        const Text("生日"),
        Text(set_birthday_controller.text),
        const Divider(
          color: StyleColor.lightgrey,
        ),
      ]),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () async {
            switchIsRead();
            UserData userData = UserData(
                id: widget.userData.id,
                username: set_username_controller.text,
                birthday: set_birthday_controller.text,
                account: set_account_controller.text,
                password: set_password_controller.text,
                activity: widget.userData.activity);
            if (await UserTB.updateUser(userData)) {
              Utilities.showSnackBar(
                  context, "編輯成功!", const Duration(seconds: 1), Duration.zero);
            } else {
              Utilities.showSnackBar(context, "過程中遇到了錯誤",
                  const Duration(seconds: 1), Duration.zero);
            }
            context.pop();
          },
          style: const ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStatePropertyAll(StyleColor.green)),
          child: const Text("確認變更", style: TextStyle(color: StyleColor.white)),
        ),
        TextButton(
            onPressed: () {
              context.pop();
              showDialog(
                  context: context,
                  builder: (context) {
                    return askForCancelEditAlertDialog();
                  });
            },
            style: const ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStatePropertyAll(StyleColor.red)),
            child: const Text("取消", style: TextStyle(color: StyleColor.white))),
      ],
    );
  }

  Widget askForCancelEditAlertDialog() {
    return AlertDialog(
      title: const Text("要取消編輯嗎?"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          style: const ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStatePropertyAll(StyleColor.green)),
          child: const Text("繼續編輯", style: TextStyle(color: StyleColor.white)),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            switchIsRead();
            set_account_controller.text = widget.userData.account;
            set_birthday_controller.text = widget.userData.birthday;
            set_username_controller.text = widget.userData.username;
            set_password_controller.text = widget.userData.password;
            Utilities.showSnackBar(context, "已還原到編輯前的設定",
                const Duration(seconds: 1), Duration.zero);
          },
          style: const ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStatePropertyAll(StyleColor.red)),
          child: const Text("放棄", style: TextStyle(color: StyleColor.white)),
        )
      ],
    );
  }

  Widget userPageAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "帳戶設置",
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
          if (isRead == true) {
            UserData userData = await UserTB.getDataById(widget.userData.id);
            if (mounted) {
              context.pushReplacement("/home", extra: userData);
            }
          } else {
            await showDialog(
                context: context,
                builder: (context) {
                  return askForCancelEditAlertDialog();
                });
            if (isRead == true) {
              if (mounted) {
                context.pushReplacement("/home",
                    extra: await UserTB.getDataById(widget.userData.id));
              }
            }
          }
        },
      ),
    );
  }
}
