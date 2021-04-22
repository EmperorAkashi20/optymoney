import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/constants.dart';

class ProfileComplete extends StatelessWidget {
  static String routeName = '/Completed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawerMain(),
      body: Center(
        child: Container(
          child: Text(
            'Your Profile is up to date, if you want to make any changes please tap here',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
