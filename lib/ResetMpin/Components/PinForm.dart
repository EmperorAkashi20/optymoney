import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:optymoney/LoginWithMpin/loginwithmpin.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';
import '../../size_config.dart';

makePostRequest() async {
  print(PinForm.mpin1);

  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doChangeMpinApp&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'userid': MyApp.user,
    'mpin': PinForm.mpin1,
  };
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
  PinForm.responseData = json.decode(PinForm.responseBody);
  PinForm.responseMessgae = PinForm.responseData['message'].toString();

  print("aaaaaa");
  print(statusCode);
  print(PinForm.responseMessgae);
}

class PinForm extends StatefulWidget {
  static var mpin1;
  static var responseBody;
  static var responseData;
  static var responseMessgae;
  static var checkHash;
  static var digest;

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
  static TextEditingController pass = TextEditingController();
  //static TextEditingController nodeFive = TextEditingController();
  //static TextEditingController nodeSix = TextEditingController();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  Timer? _timer;
  late double _progress;
  final List<String?> errors = [];
  final _formKey = GlobalKey<FormState>();

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
      key: _formKey,
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
          SizedBox(height: SizeConfig.screenHeight * 0.09),
          buildPasswordFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          FormError(errors: errors),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
                var hashedPass = utf8.encode(pass.text);
                PinForm.digest = sha512256.convert(hashedPass);
                print(PinForm.digest.toString());
                PinForm.mpin1 = a + b + c + d;
                if (PinForm.digest.toString() == MyApp.hash.toString()) {
                  removeError(error: kPasswordNotValidError);
                  await makePostRequest();
                  if (PinForm.responseMessgae == 'MPIN_CHANGED') {
                    _progress = 0;
                    _timer?.cancel();
                    _timer = Timer.periodic(const Duration(milliseconds: 10),
                        (Timer timer) async {
                      await EasyLoading.showProgress(_progress,
                          status: '${(_progress * 100).toStringAsFixed(0)}%');
                      _progress += 0.03;
                      if (_progress >= 1) {
                        _timer?.cancel();
                        EasyLoading.dismiss();
                      }
                    });

                    //await EasyLoading.showSuccess("Successfull");
                    // Fluttertoast.showToast(
                    //     msg: "Pin Updated Successfully",
                    //     toastLength: Toast.LENGTH_LONG,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.white10,
                    //     textColor: Colors.black,
                    //     fontSize: 12.0);
                    _formKey.currentState!.reset();
                    Future.delayed(Duration(milliseconds: 800), () async {
                      //await EasyLoading.showSuccess("Successfully Changed");
                      Navigator.pushNamed(context, LoginWIthMpin.routeName);
                    });
                  } else {
                    setState(() {
                      _formKey.currentState!.reset();
                      addError(error: "MPIN NOT CHANGED");
                    });
                  }
                } else {
                  setState(() {
                    _formKey.currentState!.reset();
                    addError(error: kPasswordNotValidError);
                  });
                }
              })
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: pass,
      obscureText: true,
      onSaved: (newValue) => PinForm.checkHash = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 2) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          removeError(error: kPasswordNotValidError);
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 2) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
