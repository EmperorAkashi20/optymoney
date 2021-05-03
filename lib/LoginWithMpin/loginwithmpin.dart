import 'package:flutter/material.dart';
import 'package:optymoney/LoginWithMpin/Components/body.dart';
import 'package:optymoney/size_config.dart';

class LoginWIthMpin extends StatelessWidget {
  static String routeName = "/mpinlogin";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
