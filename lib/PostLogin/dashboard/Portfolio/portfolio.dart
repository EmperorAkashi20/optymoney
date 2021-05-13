import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/Components/body.dart';

class Portfolio extends StatelessWidget {
  static String routeName = "/portfolio";
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
