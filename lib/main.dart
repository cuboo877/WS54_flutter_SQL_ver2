import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/page/details.dart';
import 'package:ws54_flutter_sql_ver2/page/home.dart';
import 'package:ws54_flutter_sql_ver2/page/login.dart';
import 'package:ws54_flutter_sql_ver2/page/register.dart';
import 'package:ws54_flutter_sql_ver2/page/splash.dart';
import 'package:ws54_flutter_sql_ver2/service/sql_serivce.dart';
import 'package:ws54_flutter_sql_ver2/widget/textform/account_textform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final goRouter = GoRouter(
    initialLocation: "/",
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: "/login",
        path: "/login",
        builder: (context, state) {
          if (state.extra == null) {
            return LoginPage();
          } else {
            final map = state.extra as Map<String, String>;
            return LoginPage(
              initAccount: map["account"],
              initPassword: map["password"],
            );
          }
        },
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: "/details",
        builder: (context, state) => const DetailsPage(),
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) {
          final userData = state as UserData;
          return HomePage(
            userData: userData,
          );
        },
      )
    ],
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'WS54 Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
