import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:optymoney/otp/otp_screen.dart';
import 'package:optymoney/sign_up_screen/components/sign_up_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../size_config.dart';

sendOtpRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=doSendOTP');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'email': SignUpForm.email,
    'mobile': CompleteProfileForm.phoneNumber
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
  CompleteProfileForm.responseBody = response.body.toString();
  print(statusCode);
  print(CompleteProfileForm.responseBody);
}

class CompleteProfileForm extends StatefulWidget {
  static String? firstName;
  static String? lastName;
  //static String? phoneNumber;
  static String? address;
  static var phoneNumber;
  static String? responseBody;
  static var fullName;
  static TextEditingController firstNameController =
      new TextEditingController();
  static TextEditingController lastNameController = new TextEditingController();
  static TextEditingController phone = new TextEditingController();

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () async {
              CompleteProfileForm.phoneNumber =
                  (CompleteProfileForm.phone.text);
              CompleteProfileForm.fullName =
                  (CompleteProfileForm.firstNameController.text +
                      ' ' +
                      CompleteProfileForm.lastNameController.text);
              //print(CompleteProfileForm.fullName);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (CompleteProfileForm.responseBody == 'EMAIL_EXISTS') {
                  addError(error: 'Email Already Exists');
                } else {
                  //_showToast();
                  await sendOtpRequest();
                  Navigator.pushNamed(context, OtpScreen.routeName);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // TextFormField buildAddressFormField() {
  //   return TextFormField(
  //     onSaved: (newValue) => CompleteProfileForm.address = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kAddressNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         addError(error: kAddressNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Address",
  //       hintText: "Enter your phone address",
  //       // If  you are using latest version of flutter then label text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon:
  //           CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
  //     ),
  //   );
  // }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: CompleteProfileForm.phone,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => CompleteProfileForm.phone, //= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      controller: CompleteProfileForm.lastNameController,
      keyboardType: TextInputType.text,
      onSaved: (newValue) =>
          CompleteProfileForm.lastNameController, //= newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: CompleteProfileForm.firstNameController,
      keyboardType: TextInputType.text,
      onSaved: (newValue) =>
          CompleteProfileForm.firstNameController, //= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  // _showToast() {
  //   Widget toast = Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25.0),
  //       color: Colors.greenAccent,
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(Icons.check),
  //         SizedBox(
  //           width: 12.0,
  //         ),
  //         Text("This is a Custom Toast"),
  //       ],
  //     ),
  //   );

  //   fToast.showToast(
  //     child: toast,
  //     gravity: ToastGravity.BOTTOM,
  //     toastDuration: Duration(seconds: 2),
  //   );

  //   // Custom Toast Position
  //   fToast.showToast(
  //       child: toast,
  //       toastDuration: Duration(seconds: 2),
  //       positionedToastBuilder: (context, child) {
  //         return Positioned(
  //           child: child,
  //           top: 16.0,
  //           left: 16.0,
  //         );
  //       });
  // }
}
