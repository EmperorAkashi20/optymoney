import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/complete_profile/components/complete_profile_form.dart';
import 'package:optymoney/sign_up_screen/components/sign_up_form.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants.dart';
import '../../size_config.dart';

makePostRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doSignup&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'name': CompleteProfileForm.firstName,
    'email': SignUpForm.email,
    'mobile': CompleteProfileForm.phoneNumber,
    'otp': OtpForm.otp,
    'reg_passwd': SignUpForm.password,
    'repasswd': SignUpForm.confirmPassword
  };
  print(CompleteProfileForm.phoneNumber);
  print(SignUpForm.email);
  print(OtpForm.otp);
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  print(statusCode);
  print(responseBody);
  print(response);
}

class OtpForm extends StatefulWidget {
  static var otp;

  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  static TextEditingController nodeOne = TextEditingController();
  static TextEditingController nodeTwo = TextEditingController();
  static TextEditingController nodeThree = TextEditingController();
  static TextEditingController nodeFour = TextEditingController();
  static TextEditingController nodeFive = TextEditingController();
  //static TextEditingController nodeSix = TextEditingController();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  controller: nodeOne,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  controller: nodeTwo,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  controller: nodeThree,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  controller: nodeFour,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin5FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  controller: nodeFive,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin5FocusNode!.unfocus();
                      // Then you need to check if the code is correct or not
                    }
                  },
                ),
              ),
              // SizedBox(
              //   width: getProportionateScreenWidth(40),
              //   child: TextFormField(
              //     focusNode: pin6FocusNode,
              //     obscureText: true,
              //     style: TextStyle(fontSize: 24),
              //     keyboardType: TextInputType.number,
              //     controller: nodeSix,
              //     textAlign: TextAlign.center,
              //     decoration: otpInputDecoration,
              //     onChanged: (value) {
              //       if (value.length == 1) {
              //         pin6FocusNode!.unfocus();
              //         // Then you need to check if the code is correct or not
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Continue",
            press: () {
              var a = nodeOne.text;
              var b = nodeTwo.text;
              var c = nodeThree.text;
              var d = nodeFour.text;
              var e = nodeFive.text;
              //var f = nodeSix.text;
              OtpForm.otp = a + b + c + d + e;
              makePostRequest();
            },
          )
        ],
      ),
    );
  }
}
