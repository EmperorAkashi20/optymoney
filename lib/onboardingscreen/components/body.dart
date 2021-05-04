import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intro_screen_onboarding_flutter/introduction.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:optymoney/LoginWithMpin/loginwithmpin.dart';
import 'package:optymoney/sign_in_screen/sign_in_screen.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';

class Body extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Tax',
      subTitle:
          'Personalized income tax consultation and tax filing services with expert assistance',
      imageUrl: 'assets/images/tax_vec.png',
    ),
    Introduction(
      title: 'Wealth',
      subTitle:
          'Lets you manage your financial goals and allows you to do new investments.',
      imageUrl: 'assets/images/investment.png',
    ),
    Introduction(
      title: 'Will',
      subTitle:
          'Hassle free Will creation and revision with the expert assistance.',
      imageUrl: 'assets/images/will.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyApp.user == '0' ? SignInScreen() : LoginWIthMpin(),
          ), //MaterialPageRoute
        );
      },
    );
  }
}
