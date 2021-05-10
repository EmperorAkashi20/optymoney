import 'package:flutter/material.dart';
import 'package:optymoney/PasswordReset/Components/ResetForm.dart';

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
              //SizedBox(height: SizeConfig.screenHeight * 0.05),
              Icon(
                Icons.account_circle_sharp,
                color: kPrimaryColor,
                size: 50,
              ),
              //SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "RESET Password",
                style: headingStyle,
              ),
              Text("Please enter your email and password"),
              SizedBox(height: SizeConfig.screenHeight * 0.09),
              ResetForm(),
              //SizedBox(height: SizeConfig.screenHeight * 0.1),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pushNamed(context, PostLoginStartsHere.routeName);
              //   },
              //   child: Text(
              //     "Continue",
              //     style: TextStyle(decoration: TextDecoration.underline),
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, ResetMpinScreen.routeName);
              //       },
              //       child: Text("Forgot MPIN"),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, SignInScreen.routeName);
              //       },
              //       child: Text(
              //         "Sign In With Email and Password",
              //         textAlign: TextAlign.end,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
