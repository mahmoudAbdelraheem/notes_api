import 'package:flutter/material.dart';
import 'package:notes_api/app/auth/login.dart';
import 'package:notes_api/app/auth/sign_up.dart';
import 'package:notes_api/app/home_page.dart';
import 'package:notes_api/app/notes/add_note.dart';
import 'package:notes_api/app/setting_page.dart';
import 'package:notes_api/constant/app_color.dart';

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences shardPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shardPref = await SharedPreferences.getInstance();
  //this code valed only in debug mode
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter PHP API Text',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 2,
          backgroundColor: appBarColor,
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: iconsColor,
            size: 30,
          ),
        ),
        useMaterial3: false,
      ),
      initialRoute: shardPref.getString("id") == null ? "login" : "homePage",
      routes: {
        "login": (context) => const Login(),
        "signUp": (context) => const SignUp(),
        "homePage": (context) => const HomePage(),
        "addNote": (context) => const AddNote(),
        "setting": (context) => const SettingPage(),
      },
    );
  }
}

//this code valed only in debug mode
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
