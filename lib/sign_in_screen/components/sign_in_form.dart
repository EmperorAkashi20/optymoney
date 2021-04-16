import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/otp/components/otp_form.dart';

import '../../constants.dart';
import '../../size_config.dart';

makePostRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doLoginApp&subaction=loginSubmit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'email': SignForm.email,
    'passwd': SignForm.password
  };
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
  var parsedToken = json.decode(parsedJson['token']);
  //print(parsedJson);
  print('token');
  // print(parsedToken);
  var pan1 = parsedToken['caTAX_pan_number'].toString();
  SignForm.pan = pan1;
  print(SignForm.pan);
  var userId1 = parsedToken['caTAX_user_id'].toString();
  SignForm.userId = userId1;
  print(SignForm.userId);
  SignForm.message = parsedJson['message'].toString();
  print(SignForm.message);
  SignForm.name = parsedToken['caTAX_user_name'].toString();
  print(SignForm.name);
  SignForm.email1 = parsedToken['caTAX_email_id'].toString();
  print(SignForm.email1);
  //print('${SignForm.name[0]}');
  SignForm.letter = SignForm.name[0];
  print(SignForm.letter);
}

// makePortfolioRequest() async {
//   var url = Uri.parse(
//       'https://optymoney.com/ajax-request/ajax_response.php?action=fetchPortfolioApp&subaction=submit');
//   final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
//   Map<String, dynamic> body = {
//     'uid': SignForm.userId,
//     'pan': SignForm.pan,
//   };
//   //String jsonBody = json.encode(body);
//   final encoding = Encoding.getByName('utf-8');

//   Response response = await post(
//     url,
//     headers: headers,
//     body: body,
//     encoding: encoding,
//   );

//   SignForm.portfolioCode = response.statusCode;
//   SignForm.portfolioBody = response.body;
//   print(SignForm.userId);
//   print(SignForm.portfolioBody);
//   print(SignForm.pan);
//   var jsonData = SignForm.portfolioBody;
//   print(jsonData);
//   SignForm.parsedJson = json.decode(jsonData);
//   print('test');
//   print(SignForm.parsedJson);
//   SignForm.parsedJson.forEach((foliodata) {
//     if (foliodata["all_units"] != 0) {
//       print(foliodata["isin"]);
//       SignForm.folioDataNum++;
//       SignForm.isin = foliodata["isin"];
//       SignForm.schemeName = foliodata["fr_scheme_name"];
//       SignForm.schemeCode = foliodata["fr_scheme_code"];
//       SignForm.purchasePrice = foliodata["purchase_price"];
//       //SignForm.
//       print(SignForm.purchasePrice);
//       print(SignForm.folioDataNum);
//     }
//   });
// }

class SignForm extends StatefulWidget {
  static String? email;
  static String? password;
  static var responseBody;
  static var statusCode;
  static var message;
  static var pan;
  static var userId;
  static var parsedJson;
  static var name;
  static var email1;
  static var letter;

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
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                //onTap: () => Navigator.pushNamed(
                //  context, ForgotPasswordScreen.routeName),
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
                _onLoading();
                await makePostRequest();
                CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  strokeWidth: 3,
                );
                if (SignForm.message == "LOGIN_SUCCESS") {
                  removeError(error: kNoUserError);
                  removeError(error: kNoUserError1);
                  removeError(error: kSignUp);
                  setState(() {
                    Navigator.pushNamed(context, PostLoginStartsHere.routeName);
                  });
                  //await Future.delayed(Duration(seconds: 8));

                  //_onLoading();
                  // Navigator.pushNamed(context, PostLoginStartsHere.routeName);
                } else if (SignForm.message == "LOGIN_FAILED") {
                  addError(error: kNoUserError1);
                  addError(error: kSignUp);
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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      //pop dialog
    });
  }
}
