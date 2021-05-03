// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optymoney/routes.dart';
import 'package:optymoney/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/custom_suffix_icon.dart';
import 'onboardingscreen/onboardingscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SizeConfig();
  MyApp.prefs = await SharedPreferences.getInstance();
  MyApp.user = MyApp.prefs.getString('userId') ?? '0';
  MyApp.email = MyApp.prefs.getString('emailId') ?? '0';
  MyApp.name = MyApp.prefs.getString('name') ?? '0';
  MyApp.pan = MyApp.prefs.getString('pan') ?? '0';
  print(MyApp.email);
  print(MyApp.user);
  print(MyApp.pan);
  print(MyApp.name);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  static var prefs;
  static var user;
  static var email;
  static var name;
  static var pan;
  static var hash;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(),
      debugShowCheckedModeBanner: false,
      title: 'Optymoney',
      theme: theme(),
      routes: routes,
      initialRoute: OnBoardingScreen.routeName,
    );
  }
}
