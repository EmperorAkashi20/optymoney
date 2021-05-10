import 'package:flutter/material.dart';
import 'package:optymoney/PasswordReset/Components/body.dart';

class ResetPasswordScreen extends StatelessWidget {
  static String routeName = "/resetpassword";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
