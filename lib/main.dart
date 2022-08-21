// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xiz/firebase_options.dart';
import 'package:xiz/screens/auth/registerpage.dart';
import 'package:xiz/screens/homepage.dart';
import 'package:xiz/screens/onboarding.dart';
import 'package:xiz/utils/theme.dart';

late bool isFirst;
User? user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff16161e),
    ),
  );
  final prefs = await SharedPreferences.getInstance();
  String? theme = prefs.getString('theme') ?? 'dark';
  isFirst = prefs.getBool('isFirst') ?? true;
  user = FirebaseAuth.instance.currentUser;

  runApp(
    MyApp(
      theme: theme,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);
  ThemeMode getThemeActuel() {
    switch (theme) {
      case "dark":
        return ThemeMode.dark;
      case "light":
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xizz',
      themeMode: getThemeActuel(),
      theme: ThemePerso.ligthTheme,
      darkTheme: ThemePerso.darkTheme,
      home: SwitchPage(),
    );
  }
}

class SwitchPage extends StatelessWidget {
  const SwitchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFirst
        ? Onboarding()
        : user != null
            ? HomePage(
                user: user,
              )
            : RegisterPage();
  }
}
