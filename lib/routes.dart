import 'package:flutter/widgets.dart';
import 'package:optymoney/BankDetails/bankdetails.dart';
import 'package:optymoney/Cart/cart.dart';
import 'package:optymoney/DisplayUserInfo/DisplayUserInfo.dart';
import 'package:optymoney/LoginWithMpin/loginwithmpin.dart';
import 'package:optymoney/OtherDetails/OtherDetails.dart';
import 'package:optymoney/PasswordReset/passwordresetscreen.dart';
import 'package:optymoney/PinSetup/Components/finalscreen.dart';
import 'package:optymoney/PinSetup/pinsetupscreen.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/portfolio.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/ResetMpin/resetmpin.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AllSchemeDisplay.dart';
import 'package:optymoney/SchemeDisplay/schemedisplay.dart';
import 'package:optymoney/UserInfo/Components/ProfileComplete.dart';
import 'package:optymoney/UserInfo/UserInfoStartScreen.dart';
import 'package:optymoney/complete_profile/complete_profile_screen.dart';
import 'package:optymoney/onboardingscreen/onboardingscreen.dart';
import 'package:optymoney/otp/otp_screen.dart';
import 'package:optymoney/sign_in_screen/sign_in_screen.dart';
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
  SignInScreen.routeName: (context) => SignInScreen(),
  PinSetupScreen.routeName: (context) => PinSetupScreen(),
  UserInfoScreen.routeName: (context) => UserInfoScreen(),
  Portfolio.routeName: (context) => Portfolio(),
  FinalScreen.routeName: (context) => FinalScreen(),
  OtherDetailsScreen.routeName: (context) => OtherDetailsScreen(),
  ProfileComplete.routeName: (context) => ProfileComplete(),
  DisplayUserInfoScreen.routeName: (context) => DisplayUserInfoScreen(),
  LoginWIthMpin.routeName: (context) => LoginWIthMpin(),
  ResetMpinScreen.routeName: (context) => ResetMpinScreen(),
  SchemeDisplay.routeName: (context) => SchemeDisplay(),
  ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
  BankDetailsScreen.routeName: (context) => BankDetailsScreen(),
  TestPage.routeName: (context) => TestPage(),
  AllSchemeDisplay.routeName: (context) => AllSchemeDisplay(),
  Cart.routeName: (context) => Cart(),
};
