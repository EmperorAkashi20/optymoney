import 'package:flutter/material.dart';
import 'package:optymoney/onboardingscreen/components/body.dart';
import 'package:optymoney/size_config.dart';

class OnBoardingScreen extends StatelessWidget {
  static String routeName = "/boarding";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
