import 'package:flutter/widgets.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/complete_profile/complete_profile_screen.dart';
import 'package:optymoney/onboardingscreen/onboardingscreen.dart';
import 'package:optymoney/otp/otp_screen.dart';
import 'package:optymoney/sign_up_screen/sign_up_screen.dart';
import 'package:optymoney/testpage.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
  TestPage.routeName: (context) => TestPage(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  PostLoginStartsHere.routeName: (context) => PostLoginStartsHere(),
};
