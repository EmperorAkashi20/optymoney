import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/otp/components/otp_form.dart';
import 'package:flutter/widgets.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

import '../../constants.dart';
import '../../size_config.dart';

makePostRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=savePin&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'userid': SignForm.userIdGlobal,
    'mpin': PinForm.mpin,
  };
  print(PinForm.mpin);
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  int statusCode = response.statusCode;
  PinForm.responseBody = (response.body);
  print(statusCode);
  print(PinForm.responseBody);
  PinForm.userId = OtpForm.status;
  print(PinForm.userId);
  print(OtpForm.status);
}

class PinForm extends StatefulWidget {
  static var mpin;
  static var responseBody;
  static var userId;
  const PinForm({
    Key? key,
  }) : super(key: key);

  @override
  _PinFormState createState() => _PinFormState();
}

class _PinFormState extends State<PinForm> {
  static TextEditingController nodeOne = TextEditingController();
  static TextEditingController nodeTwo = TextEditingController();
  static TextEditingController nodeThree = TextEditingController();
  static TextEditingController nodeFour = TextEditingController();
  //static TextEditingController nodeFive = TextEditingController();
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
                width: getProportionateScreenWidth(60),
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
                width: getProportionateScreenWidth(60),
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
                width: getProportionateScreenWidth(60),
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
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  controller: nodeFour,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                      // Then you need to check if the code is correct or not
                    }
                  },
                ),
              ),
              // SizedBox(
              //   width: getProportionateScreenWidth(40),
              //   child: TextFormField(
              //     focusNode: pin5FocusNode,
              //     obscureText: true,
              //     style: TextStyle(fontSize: 24),
              //     keyboardType: TextInputType.number,
              //     controller: nodeFive,
              //     textAlign: TextAlign.center,
              //     decoration: otpInputDecoration,
              //     onChanged: (value) {
              //       if (value.length == 1) {
              //         pin5FocusNode!.unfocus();
              //         // Then you need to check if the code is correct or not
              //       }
              //     },
              //   ),
              // ),
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
            press: () async {
              var a = nodeOne.text;
              var b = nodeTwo.text;
              var c = nodeThree.text;
              var d = nodeFour.text;
              //var e = nodeFive.text;
              //var f = nodeSix.text;
              PinForm.mpin = a + b + c + d;
              await makePostRequest();
              if (PinForm.responseBody != 1) {
                Navigator.pushNamed(context, PostLoginStartsHere.routeName);
              } else {
                print("error");
              }
            },
          )
        ],
      ),
    );
  }
}
