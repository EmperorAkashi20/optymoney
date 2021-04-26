// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/custom_suffix_icon.dart';
import 'onboardingscreen/onboardingscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MyApp.loginStatus = prefs.getBool('isLoggedIn') ?? false;
  print(MyApp.loginStatus);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  static var loginStatus;
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
