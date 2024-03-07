import 'package:flutter/material.dart';
import 'package:ws54_flutter_sql_ver2/constant/styleguide.dart';
import 'package:ws54_flutter_sql_ver2/page/user.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';
import 'package:go_router/go_router.dart';

import '../service/utilities.dart';
import '../widget/logout_button.dart';

class HomePage extends StatefulWidget {
  final UserData userData;
  const HomePage({super.key, required this.userData});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey();
  List<PasswordData> passwordList = [];
  late TextEditingController url_contoller;
  late TextEditingController name_contoller;
  late TextEditingController id_contoller;
  late TextEditingController tag_contoller;
  late TextEditingController password_contoller;
  late TextEditingController login_contoller;
  // for SearchSetting
  int hasFav = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setPasswordList();
    });
    url_contoller = TextEditingController();
    name_contoller = TextEditingController();
    id_contoller = TextEditingController();
    tag_contoller = TextEditingController();
    password_contoller = TextEditingController();
    login_contoller = TextEditingController();
    print("post value");
  }

  @override
  void dispose() {
    url_contoller.dispose();
    name_contoller.dispose();
    id_contoller.dispose();
    tag_contoller.dispose();
    password_contoller.dispose();
    login_contoller.dispose();
    super.dispose();
  }

  void setPasswordList() async {
    Object result = await PasswordsTB.getPasswordsByUserID(widget.userData.id);
    setState(() {
      if (result != false) {
        passwordList = result as List<PasswordData>;
        print("got password list");
      } else {
        passwordList = [];
        print("didnt get password list");
      }
    });
  }

  void setPasswordListWithCondition() async {
    Object result = await PasswordsTB.getPasswordDataByUserIDAndCondition(
        url: url_contoller.text.trim(),
        userID: widget.userData.id,
        tag: tag_contoller.text.trim(),
        login: login_contoller.text.trim(),
        password: password_contoller.text.trim(),
        id: id_contoller.text,
        isFav: hasFav);
    setState(() {
      if (result != false) {
        passwordList = result as List<PasswordData>;
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: StyleColor.darkBlue,
            duration: const Duration(seconds: 3),
            content: const Text(
              "已找到相似的結果",
              style: TextStyle(color: StyleColor.white, fontSize: 20),
            ),
            action: SnackBarAction(
                textColor: StyleColor.white,
                label: "還原",
                onPressed: () {
                  setPasswordList();
                  Utilities.showSnackBar(context, "已還原",
                      const Duration(seconds: 1), Duration.zero);
                }),
          ));
        }
        print("got password list");
      } else {
        passwordList = [];
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: StyleColor.darkBlue,
            duration: const Duration(seconds: 3),
            content: const Text(
              "未在資料庫找到相關的密碼",
              style: TextStyle(color: StyleColor.white, fontSize: 20),
            ),
            action: SnackBarAction(
                textColor: StyleColor.white,
                label: "還原",
                onPressed: () {
                  setPasswordList();
                  Utilities.showSnackBar(context, "已還原",
                      const Duration(seconds: 1), Duration.zero);
                }),
          ));
        }
        print("didnt get password list");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingAddPasswordButton(),
        backgroundColor: StyleColor.white,
        key: _scaffoldKey,
        drawer: navDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: homeAppBar(),
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(
                parent: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast)),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "密碼庫",
                    style: CustomFont.bigDarkBlueTitle,
                  ),
                  searchSettingBar(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: passwordMenu(),
                  ),
                ],
              ),
            )));
  }

  Widget passwordMenu() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
        ),
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: passwordList.length,
            itemBuilder: ((context, index) {
              return _passwordTile(passwordList[index]);
            })));
  }

  Widget _passwordTile(PasswordData passwordData) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Container(
        decoration: BoxDecoration(
            color: StyleColor.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: StyleColor.darkBlue, width: 4.0)),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          leading: IconButton(
            onPressed: () async {
              setState(() {
                passwordData.isFavorite = passwordData.isFavorite == 0 ? 1 : 0;
              });
              await PasswordsTB.switchPasswordFavoriteByPasswordID(
                  passwordData, passwordData.isFavorite);
            },
            icon: passwordData.isFavorite == 1
                ? const Icon(
                    Icons.favorite,
                    color: StyleColor.red,
                  )
                : const Icon(Icons.favorite_border, color: StyleColor.red),
          ),
          title: Text(
            passwordData.name,
            style: const TextStyle(
                color: StyleColor.darkBlue,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Averta"),
          ),
          children: [
            ListTile(
              title: const Text("URL"),
              leading: const Icon(Icons.link),
              trailing: SizedBox(
                width: 160,
                child: Text(
                  passwordData.url,
                  style: const TextStyle(
                      fontSize: 20,
                      color: StyleColor.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Averta"),
                ),
              ),
            ),
            ListTile(
              title: const Text("登入帳號"),
              leading: const Icon(Icons.email),
              trailing: SizedBox(
                width: 160,
                child: Text(
                  passwordData.login,
                  style: const TextStyle(
                      fontSize: 20,
                      color: StyleColor.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Averta"),
                ),
              ),
            ),
            ListTile(
                title: const Text("密碼"),
                leading: const Icon(Icons.key),
                trailing: SizedBox(
                  width: 160,
                  child: Text(
                    passwordData.password,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 20,
                        color: StyleColor.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Averta"),
                  ),
                )),
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        elevation: 3,
                        shape: const CircleBorder(),
                        backgroundColor: StyleColor.green,
                        iconColor: StyleColor.white),
                    onPressed: () {
                      context.push("/edit", extra: passwordData);
                    },
                    child: const Icon(
                      Icons.edit,
                    )),
                TextButton(
                    style: TextButton.styleFrom(
                        elevation: 3,
                        shape: const CircleBorder(),
                        backgroundColor: StyleColor.red,
                        iconColor: StyleColor.white),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actionsAlignment: MainAxisAlignment.center,
                              title: const Text("確定刪除此密碼嗎?"),
                              actions: [
                                TextButton(
                                    style: const ButtonStyle(
                                        alignment: Alignment.center,
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(45)))),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                StyleColor.red)),
                                    onPressed: () async {
                                      await PasswordsTB
                                          .deletePasswordByPasswordID(
                                              passwordData.id);
                                      if (mounted) {
                                        setPasswordList();
                                        context.pop();
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "確定刪除",
                                          style: TextStyle(
                                              color: StyleColor.white,
                                              fontSize: 20),
                                        ),
                                        Icon(
                                          Icons.delete,
                                          color: StyleColor.white,
                                          size: 18,
                                        )
                                      ],
                                    )),
                                TextButton(
                                    style: const ButtonStyle(
                                        alignment: Alignment.center,
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(45)))),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                StyleColor.green)),
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "取消",
                                          style: TextStyle(
                                              color: StyleColor.white,
                                              fontSize: 20),
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          color: StyleColor.white,
                                          size: 18,
                                        )
                                      ],
                                    ))
                              ],
                            );
                          });
                    },
                    child: const Icon(
                      Icons.delete,
                    )),
                const SizedBox(
                  width: 50,
                ),
                Text("資料庫ID : ${passwordData.id}")
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget searchSettingBar() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 4),
          child: Container(
              width: 340,
              decoration: BoxDecoration(
                  color: StyleColor.soFkLightGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: StyleColor.lightgrey, width: 2.0)),
              child: ExpansionTile(
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                textColor: StyleColor.black,
                title: const Text("搜尋設定"),
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text("標籤")),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: tag_contoller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.tag), hintText: "tag"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text("URL")),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: url_contoller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.link),
                              hintText: "website url"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text("登入帳號")),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: login_contoller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email), hintText: "login"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text("密碼")),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: password_contoller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              hintText: "password"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text("資料庫ID")),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: id_contoller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              hintText: "Password ID"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: StyleColor.black,
                            activeColor: Colors.transparent,
                            title: const Text("使用者ID"),
                            value: (true),
                            onChanged: (value) {}),
                      ),
                      Expanded(
                          child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              checkColor: StyleColor.white,
                              activeColor: StyleColor.black,
                              title: const Text("我的最愛"),
                              value: (hasFav == 1 ? true : false),
                              onChanged: (value) {
                                setState(() => hasFav = value == true ? 1 : 0);
                              }))
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          setPasswordListWithCondition();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            side: const BorderSide(
                                width: 2.0, color: StyleColor.lightgrey)),
                        child: const Text(
                          "套用",
                          style: TextStyle(
                              color: StyleColor.lightgrey, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            tag_contoller.text = "";
                            url_contoller.text = "";
                            login_contoller.text = "";
                            password_contoller.text = "";
                            id_contoller.text = "";
                            hasFav = 0;
                          });
                          setPasswordList();
                          Utilities.showSnackBar(context, "已清空搜尋的設定",
                              const Duration(seconds: 1), Duration.zero);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            side: const BorderSide(
                                width: 2.0, color: StyleColor.lightgrey)),
                        child: const Text(
                          "清空設定",
                          style: TextStyle(
                              color: StyleColor.lightgrey, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          setPasswordList();
                          Utilities.showSnackBar(context, "已取消搜尋模式",
                              const Duration(seconds: 1), Duration.zero);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            side: const BorderSide(
                                width: 2.0, color: StyleColor.lightgrey)),
                        child: const Text(
                          "取消搜尋",
                          style: TextStyle(
                              color: StyleColor.lightgrey, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )));
    });
  }

  Widget floatingAddPasswordButton() {
    return FloatingActionButton(
      heroTag: "Add password button tag",
      onPressed: () {
        context.push("/create");
      },
      backgroundColor: StyleColor.darkBlue,
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }

  Widget homeAppBar() {
    return AppBar(
      backgroundColor: StyleColor.darkBlue,
      centerTitle: true,
      title: const Text(
        "主畫面",
        style: TextStyle(color: StyleColor.white),
      ),
    );
  }

  Widget navDrawer() {
    return Drawer(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 23,
                          )),
                      Image.asset(
                        "assets/icon.png",
                        width: 23,
                        height: 23,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                )),
            ListTile(
              onTap: () {
                context.pop();
              },
              title: const Text(
                "主畫面",
                style: TextStyle(fontSize: 25),
              ),
              leading: const Icon(
                Icons.home,
                color: StyleColor.black,
                size: 25,
              ),
              textColor: StyleColor.black,
            ),
            ListTile(
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                context.push("/user", extra: widget.userData);
              },
              title: const Text(
                "帳戶設定",
                style: TextStyle(fontSize: 25),
              ),
              leading: const Icon(
                Icons.person,
                color: StyleColor.black,
                size: 25,
              ),
              textColor: StyleColor.black,
            ),
            logOutButton(context, widget.userData)
          ],
        ),
      ),
    );
  }
}
