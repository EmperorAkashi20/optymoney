import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optymoney/routes.dart';

import 'Components/custom_suffix_icon.dart';
import 'onboardingscreen/onboardingscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
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
