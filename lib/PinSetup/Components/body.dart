import 'package:flutter/material.dart';
import 'package:optymoney/PinSetup/Components/form.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';

import '../../constants.dart';
import '../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "MPIN SETUP",
                style: headingStyle,
              ),
              Text("Please set your MPIN"),
              PinForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PostLoginStartsHere.routeName);
                },
                child: Text(
                  "Continue",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
