import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/service/auth.dart';
import 'package:ws54_flutter_sql_ver2/service/sharedPref.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';
import 'package:ws54_flutter_sql_ver2/service/utilities.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _delayNavToHomeOrLogin();
  }

  void _delayNavToHomeOrLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // if (mounted) {
    //   if (await Auth.checkLogged()) {
    //     try {
    //       UserData ud = UserTB.getDataByActivity() as UserData;
    //       context.goNamed("/home", extra: ud);
    //     } catch (e) {
    //       context.go("/login");
    //     }
    //   } else {
    //     context.go("/login");
    //   }
    // }
    try {
      if (await Auth.checkLogged()) {
        String loggedAccount = await sharedPref.getLoggedAccount();
        UserData userData = await UserTB.getDataByAccount(loggedAccount);
        // ignore: use_build_context_synchronously
        context.go("/home", extra: userData);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Utilities.showSnackBar(context, "歡迎回來! 使用者: ${userData.username}",
              const Duration(seconds: 2), Duration.zero);
        });
      } else {
        // ignore: use_build_context_synchronously
        context.go("/login");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      context.go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/icon.png",
        width: 200,
        height: 200,
      ),
    );
  }
}
