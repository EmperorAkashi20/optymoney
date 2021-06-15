import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

import '../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';
import '../../size_config.dart';

makePostRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doLoginAppWithPin&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'userid': MyApp.user,
    'mpin': PinForm.mpin,
  };
  //print(PinForm.mpin);
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  PinForm.responseBody = (response.body);
  PinForm.responseData = json.decode(PinForm.responseBody);
  PinForm.responseMessgae = PinForm.responseData['message'].toString();
  if (PinForm.responseMessgae != 'LOGIN_FAILED') {
    PinForm.parsedToken = json.decode(PinForm.responseData['token']);
    PinForm.responseUser = PinForm.parsedToken['caTAX_user_id'].toString();
    PinForm.responsePan = PinForm.parsedToken['caTAX_pan_number'].toString();

    SignForm.userIdGlobal = PinForm.responseUser;
    SignForm.pan = PinForm.responsePan;
  } else {
    print('oops');
  }
}

class PinForm extends StatefulWidget {
  static var mpin;
  static var responseBody;
  static var userId;
  static var responseData;
  static var responseMessgae;
  static var responseUser;
  static var responsePan;
  static var parsedToken;
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
  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  checkLocalAuthPossible() async {
    var localAuth = LocalAuthentication();
    bool canCheckBiomteric = await localAuth.canCheckBiometrics;
    print(canCheckBiomteric.toString());
    List<BiometricType> availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
      }
    }
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        biometricOnly: true);
    print(didAuthenticate.toString());
  }

  @override
  void initState() {
    super.initState();
    //checkLocalAuthPossible();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode!.dispose();
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
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(60),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        focusNode: pin1FocusNode,
                        autofocus: true,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        controller: nodeOne,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).requestFocus(pin2FocusNode);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(60),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        focusNode: pin2FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        controller: nodeTwo,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).requestFocus(pin3FocusNode);
                          } else if (value.isEmpty) {
                            FocusScope.of(context).requestFocus(pin1FocusNode);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(60),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: TextFormField(
                        focusNode: pin3FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        controller: nodeThree,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).requestFocus(pin4FocusNode);
                          } else if (value.isEmpty) {
                            FocusScope.of(context).requestFocus(pin2FocusNode);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(60),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
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
                          } else if (value.isEmpty) {
                            FocusScope.of(context).requestFocus(pin3FocusNode);
                          }
                        },
                      ),
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
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              FormError(errors: errors),
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
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }
              await makePostRequest();
              if (PinForm.responseMessgae != "LOGIN_FAILED") {
                removeError(error: kWrongPinError);
                _formKey.currentState!.reset();
                Navigator.pushNamed(context, PostLoginStartsHere.routeName);
              } else {
                setState(() {
                  addError(error: kWrongPinError);
                  _formKey.currentState!.reset();
                });
              }
            },
          )
        ],
      ),
    );
  }
}
