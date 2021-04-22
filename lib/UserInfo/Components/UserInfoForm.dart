import 'package:flutter/material.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:optymoney/OtherDetails/OtherDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../size_config.dart';

class UserInfoForm extends StatefulWidget {
  static String? pan;
  static String? aadhar;
  static String? nominee;
  static String? relation;

  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
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
          buildAadharFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPanFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNomineeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildRelationFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Next",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                //_showToast();
                Navigator.pushNamed(context, OtherDetailsScreen.routeName);
                //sendOtpRequest();

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPanFormField() {
    return TextFormField(
      onSaved: (newValue) => UserInfoForm.pan = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmptyFieldError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmptyFieldError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "PAN Number",
        hintText: "AAAAAAAAA",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
      ),
    );
  }

  TextFormField buildAadharFormField() {
    return TextFormField(
      onSaved: (newValue) => UserInfoForm.aadhar = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmptyFieldError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmptyFieldError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "AADHAR Number",
        hintText: "XXXX XXXX XXXX",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
      ),
    );
  }

  TextFormField buildNomineeFormField() {
    return TextFormField(
      onSaved: (newValue) => UserInfoForm.nominee = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmptyFieldError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmptyFieldError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nominee Name",
        hintText: "Please enter the name",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildRelationFormField() {
    return TextFormField(
      onSaved: (newValue) => UserInfoForm.relation = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmptyFieldError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmptyFieldError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Relation With Nominee",
        hintText: "Please enter Your relation",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  // TextFormField buildPhoneNumberFormField() {
  //   return TextFormField(
  //     controller: UserInfoForm.phone,
  //     keyboardType: TextInputType.number,
  //     onSaved: (newValue) => UserInfoForm.phone, //= newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kPhoneNumberNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         addError(error: kPhoneNumberNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Phone Number",
  //       hintText: "Enter your phone number",
  //       // If  you are using latest version of flutter then label text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
  //     ),
  //   );
  // }

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This is a Custom Toast"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
  }
}
