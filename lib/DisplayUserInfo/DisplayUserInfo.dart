import 'package:flutter/material.dart';
import 'package:optymoney/DisplayUserInfo/Components/Body.dart';

class DisplayUserInfoScreen extends StatelessWidget {
  static String routeName = "/DisplayInfo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Body(),
    );
  }
}
