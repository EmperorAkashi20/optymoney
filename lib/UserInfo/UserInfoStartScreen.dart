import 'package:flutter/material.dart';
import 'package:optymoney/UserInfo/Components/UserInfo.dart';

class UserInfoScreen extends StatelessWidget {
  static String routeName = "/UserInfo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UserInfo(),
    );
  }
}
