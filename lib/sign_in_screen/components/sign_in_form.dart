import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:optymoney/PasswordReset/passwordresetscreen.dart';
import 'package:optymoney/PinSetup/pinsetupscreen.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:crypto/crypto.dart';

import '../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../../main.dart';
import '../../size_config.dart';

makePostRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doLoginApp&subaction=loginSubmit');
  final headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({'email': SignForm.email, 'passwd': SignForm.password});
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  SignForm.statusCode = response.statusCode;
  SignForm.responseBody = response.body;
  print(SignForm.responseBody);
  var jsonData = SignForm.responseBody;

  var parsedJson = json.decode(jsonData);
  SignForm.status = parsedJson['status'].toString();
  //print(SignForm.status);
  SignForm.message = parsedJson['message'].toString();
  //print(SignForm.message);
  if (SignForm.status != '0') {
    SignForm.parsedToken = json.decode(parsedJson['token']);

    var pan1 = SignForm.parsedToken['caTAX_pan_number'].toString();
    SignForm.pan = pan1;
    var userId1 = SignForm.parsedToken['caTAX_user_id'].toString();
    SignForm.userId = userId1;
    SignForm.userIdGlobal = SignForm.userId;

    SignForm.name = SignForm.parsedToken['caTAX_user_name'].toString();
    SignForm.email1 = SignForm.parsedToken['caTAX_email_id'].toString();

    SignForm.letter = SignForm.name[0];
    //

  } else {
    print("cool");
  }
}

checkUserPinSet() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=checkMPINApp&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'uid': SignForm.userId,
  };
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  SignForm.pinBody = response.body;
  SignForm.pinStatusCode = response.statusCode;
  print(response.body);

  SignForm.pindecodedjson = json.decode(SignForm.pinBody);
  SignForm.pindecodedjsonmessage =
      SignForm.pindecodedjson['message'].toString();
}

makePortfolioRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=fetchPortfolioApp&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'uid': SignForm.userId,
    'pan': SignForm.pan,
  };
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  SignForm.portfolioCode = response.statusCode;
  SignForm.portfolioBody = response.body;
  var jsonData = SignForm.portfolioBody;
  SignForm.parsedJson = json.decode(jsonData);
  SignForm.parsedJson.forEach((foliodata) {
    if (foliodata["all_units"] != 0) {
      SignForm.isin = foliodata["isin"];
      SignForm.schemeName = foliodata["fr_scheme_name"];
      SignForm.schemeCode = foliodata["fr_scheme_code"];
      SignForm.purchasePrice = foliodata['amount'];
      SignForm.investedValue = SignForm.investedValue + SignForm.purchasePrice;
    }
  });
}

class SignForm extends StatefulWidget {
  static String? email;
  static String? password;
  static var investedValue = 0.0;
  static var responseBody;
  static var statusCode;
  static var message;
  static var pan;
  static var userId;
  static var parsedJson;
  static var name;
  static var email1;
  static var letter;
  static var parsedToken;
  static var status;
  static var portfolioCode;
  static var portfolioBody;
  static var folioDataNum;
  static var isin;
  static var schemeName;
  static var schemeCode;
  static var purchasePrice;
  static var userIdGlobal;
  static var userBday;
  static var userAddress1;
  static var userAddress2;
  static var userAddress3;
  static var userMobile;
  static var userCity;
  static var userState;
  static var userPinCode;
  static var userCountry;
  static var pinBody;
  static var pinStatusCode;
  static var pindecodedjson;
  static var pindecodedjsonmessage;
  static var digest;
  static var kycStatus;
  static var nomineeName;
  static var nomineeRelation;
  static var aadhar;

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
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
          Row(
            children: [
              // Checkbox(
              //   value: remember,
              //   activeColor: kPrimaryColor,
              //   onChanged: (value) {
              //     setState(() {
              //       remember = value;
              //     });
              //   },
              // ),
              //Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, ResetPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
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
                        Text("Please wait"),
                      ],
                    ),
                  ),
                );

                await makePostRequest();
                if (SignForm.message == "LOGIN_SUCCESS") {
                  removeError(error: kNoUserError);
                  removeError(error: kNoUserError1);
                  removeError(error: kSignUp);
                  //await makePortfolioRequest();
                  await MyApp.prefs.setString('userId', SignForm.userIdGlobal);
                  await MyApp.prefs.setString('emailId', SignForm.email1);
                  await MyApp.prefs.setString('name', SignForm.name);
                  await MyApp.prefs.setString('pan', SignForm.pan);
                  await MyApp.prefs.setString('pin', "");
                  var hashedPass = utf8.encode(SignForm.password.toString());
                  SignForm.digest = sha512256.convert(hashedPass);
                  await MyApp.prefs
                      .setString('hash', SignForm.digest.toString());
                  await checkUserPinSet();
                  _formKey.currentState!.reset();
                  if (SignForm.pindecodedjsonmessage == 'MPIN_SET') {
                    Navigator.pushNamed(context, PostLoginStartsHere.routeName);
                  } else {
                    Navigator.pushNamed(context, PinSetupScreen.routeName);
                  }
                } else if (SignForm.status == '0') {
                  setState(() {
                    addError(error: kNoUserError1);
                    addError(error: kSignUp);
                    _formKey.currentState!.reset();
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => SignForm.password = newValue,
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => SignForm.email = newValue,
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
