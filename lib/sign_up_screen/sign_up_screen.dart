import 'package:flutter/material.dart';
import 'package:optymoney/sign_up_screen/components/body.dart';


class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Body(),
    );
  }
}
