import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:crypto/crypto.dart';
import 'package:optymoney/sign_in_screen/sign_in_screen.dart';

import '../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';
import '../../size_config.dart';

sendResetPasswordRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doResetPasswordApp&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'reset_email': ResetForm.email,
  };
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  var responseBody = response.body;
  var jsonData = responseBody;
  var parsedJson = json.decode(jsonData);
  ResetForm.requestMessage = parsedJson['message'].toString();
  ResetForm.requestStatus = parsedJson['status'].toString();
  ResetForm.codeReceived = parsedJson['resetcode'].toString();
  print(ResetForm.requestMessage);
  print(ResetForm.requestStatus);
  print(ResetForm.codeReceived);
}

makeChangePasswordRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doChangePasswordApp&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'resetemail': ResetForm.email,
    'reset_passwd': ResetForm.password,
    'resrepasswd': ResetForm.confirmPassword,
    'resetcode': ResetForm.codeReceived,
  };
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  var responseBody = response.body;
  var jsonData = responseBody;
  var parsedJson = json.decode((jsonData));
  ResetForm.changeStatus = parsedJson['status'].toString();
  ResetForm.changeMessage = parsedJson['message'].toString();
  print(ResetForm.changeStatus);
  print(ResetForm.changeMessage);
}

class ResetForm extends StatefulWidget {
  static String? email;
  static String? password;
  static String? confirmPassword;
  static String? codeReceived;
  static String? requestMessage;
  static String? requestStatus;
  static String? changeStatus;
  static String? changeMessage;

  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _formKey = GlobalKey<FormState>();
  bool? remember = false;
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: remember,
          //       activeColor: kPrimaryColor,
          //       onChanged: (value) {
          //         setState(() {
          //           remember = value;
          //         });
          //       },
          //     ),
          //     Text("Remember me"),
          //     Spacer(),
          //     GestureDetector(
          //       //onTap: () => Navigator.pushNamed(
          //       //  context, ForgotPasswordScreen.routeName),
          //       child: Text(
          //         "Forgot Password",
          //         style: TextStyle(decoration: TextDecoration.underline),
          //       ),
          //     )
          //   ],
          // ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
              text: "Continue",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator.adaptive(),
                          Text("PLease wait"),
                        ],
                      ),
                    ),
                  );
                  await sendResetPasswordRequest();
                  if (ResetForm.requestStatus != '0') {
                    var hashedPass = utf8.encode(ResetForm.password.toString());
                    var digest = sha512256.convert(hashedPass);
                    var hashedPass1 =
                        utf8.encode((ResetForm.confirmPassword.toString()));
                    var digest1 = sha512256.convert(hashedPass1);
                    if (digest == digest1) {
                      await makeChangePasswordRequest();
                      if (ResetForm.changeMessage == 'PASSWORD_CHANGED') {
                        await EasyLoading.showSuccess('Successfully Changed');
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      } else {
                        setState(() {
                          addError(
                              error:
                                  'Something Went Wrong, Please Try again later');
                        });
                      }
                    } else {
                      setState(() {
                        addError(error: kMatchPassError);
                      });
                    }
                  } else {
                    setState(() {
                      addError(
                          error:
                              'Something Went Wrong, Please try again later');
                    });
                  }
                }
              }),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => ResetForm.password = newValue,
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

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => ResetForm.confirmPassword = newValue,
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
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 2) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => ResetForm.email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
