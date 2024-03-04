import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/service/auth.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';

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
    if (mounted) {
      if (await Auth.checkLogged()) {
        UserData ud = await UserTB.getDataByActivity();
        context.goNamed("/home", extra: ud);
      } else {
        context.go("/login");
      }
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
