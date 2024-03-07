import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ws54_flutter_sql_ver2/page/create.dart';
import 'package:ws54_flutter_sql_ver2/page/details.dart';
import 'package:ws54_flutter_sql_ver2/page/edit.dart';
import 'package:ws54_flutter_sql_ver2/page/home.dart';
import 'package:ws54_flutter_sql_ver2/page/login.dart';
import 'package:ws54_flutter_sql_ver2/page/register.dart';
import 'package:ws54_flutter_sql_ver2/page/splash.dart';
import 'package:ws54_flutter_sql_ver2/page/user.dart';
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
          return const LoginPage();
        },
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: "/details",
        builder: (context, state) {
          Map<String, String> extra = state.extra as Map<String, String>;
          return DetailsPage(
            account: extra["account"]!,
            password: extra["password"]!,
          );
        },
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) {
          final extra = state.extra as UserData;
          return HomePage(
            userData: extra,
          );
        },
      ),
      GoRoute(
        name: "/user",
        path: "/user",
        builder: (context, state) {
          UserData userData = state.extra as UserData;
          return UserPage(
            userData: userData,
          );
        },
      ),
      GoRoute(
        name: "/create",
        path: "/create",
        builder: (context, state) {
          return const CreatePage();
        },
      ),
      GoRoute(
        name: "/edit",
        path: "/edit",
        builder: (context, state) {
          final extra = state.extra as PasswordData;
          return EditPage(passwordData: extra);
        },
      ),
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
