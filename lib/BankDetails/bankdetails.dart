import 'package:flutter/material.dart';
import 'package:optymoney/BankDetails/Components/Body.dart';

class BankDetailsScreen extends StatelessWidget {
  static String routeName = "\bankDetails";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
