import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/Components/default_button.dart';
import 'package:optymoney/Components/form_error.dart';
import 'package:optymoney/Components/suffix_icon.dart';
import 'package:optymoney/OtherDetails/OtherDetails.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/UserInfo/Components/UserInfoForm.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

import '../../constants.dart';
import '../../size_config.dart';

makeUserRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=settinginfo&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'cust_name': SignForm.name,
    'birthday': OtherDetailsForm.bday1,
    'sex': OtherDetailsForm.sex,
    'aadhar_num': UserInfoForm.aadhar,
    'nominee': UserInfoForm.nominee,
    'line1': OtherDetailsForm.address1,
    'line2': OtherDetailsForm.address2,
    'line3': OtherDetailsForm.address3,
    'city': OtherDetailsForm.city,
    'state': OtherDetailsForm.state,
    'pincode': OtherDetailsForm.pin,
    'country': OtherDetailsForm.country,
    'r_of_nominee_w_app': UserInfoForm.relation,
    'uid': SignForm.userIdGlobal,
  };
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  print("aaa");
  OtherDetailsForm.statusCode = response.statusCode;
  print(OtherDetailsForm.statusCode);
  OtherDetailsForm.responseBody = response.body;
  print(OtherDetailsForm.responseBody);
  var jsonData = OtherDetailsForm.responseBody;

  var parsedJson = json.decode(jsonData);
  print(parsedJson);
  print(SignForm.name);
  print(SignForm.userIdGlobal);
  print(OtherDetailsForm.bday1);
  print(OtherDetailsForm.sex);
  print(OtherDetailsForm.address1);
  print(OtherDetailsForm.address2);
  print(OtherDetailsForm.address3);
  print(OtherDetailsForm.city);
  print(OtherDetailsForm.state);
  print(OtherDetailsForm.pin);
  print(OtherDetailsForm.country);
  print(UserInfoForm.aadhar);
  print(UserInfoForm.pan);
  print(UserInfoForm.nominee);
  print(UserInfoForm.relation);
}

class OtherDetailsForm extends StatefulWidget {
  static String? address1;
  static String? address2;
  static String? address3;
  static String? city;
  static String? state;
  static String? pin;
  static String sex = 'Male';
  static String? country;
  static String bday = "";
  static String bday1 = "";
  static var statusCode;
  static var responseBody;

  @override
  _OtherDetailsFormState createState() => _OtherDetailsFormState();
}

class _OtherDetailsFormState extends State<OtherDetailsForm> {
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        helpText: "SELECT YOUR DATE OF BIRTH",
        confirmText: "CONFIRM",
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark(),
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        OtherDetailsForm.bday = picked.toString();
        OtherDetailsForm.bday1 = OtherDetailsForm.bday.substring(0, 10);
      });
  }

  var _options = ['Male', 'Female', 'Trans', 'Rather Not Say'];
  String _currentItemSelected = 'Male';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 43.0),
            child: Text(
              "Sex",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(26),
              ),
              height: getProportionateScreenHeight(60),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 37),
                    child: DropdownButton<String>(
                      elevation: 0,
                      items: _options.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (String? newValueSelected) {
                        _dropDownItemSelected(newValueSelected);
                        OtherDetailsForm.sex = _currentItemSelected;
                        print("aaa");
                        print(OtherDetailsForm.sex);
                      },
                      value: _currentItemSelected,
                    ),
                  ),
                  CustomSurffixIcon(svgIcon: 'assets/icons/User.svg'),
                ],
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Padding(
            padding: const EdgeInsets.only(left: 43.0),
            child: Text(
              "Date Of Birth",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            height: getProportionateScreenHeight(60),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.0),
                    child: Text(
                      "Tap to Select",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(OtherDetailsForm.bday1),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressLineOneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressLineTwoFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressLineThreeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCityFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildStateFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPinCodeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //buildPanFormField(),
          //SizedBox(height: getProportionateScreenHeight(30)),
          buildCountryFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //buildRelationFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Next",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                await makeUserRequest();
                Navigator.pushNamed(context, PostLoginStartsHere.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressLineOneFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.address1 = newValue,
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
        labelText: "Address",
        hintText: "Line 1",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildAddressLineTwoFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.address2 = newValue,
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
        labelText: "Address",
        hintText: "Line 2",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildAddressLineThreeFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.address3 = newValue,
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
        labelText: "Address",
        hintText: "Line 3",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPinCodeFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.pin = newValue,
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
        labelText: "Area PIN",
        hintText: "Enter your 6 digit PIN",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.city = newValue,
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
        labelText: "City",
        hintText: "Please enter your City",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
      ),
    );
  }

  TextFormField buildStateFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.state = newValue,
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
        labelText: "State",
        hintText: "Please enter Your State",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
      ),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      onSaved: (newValue) => OtherDetailsForm.country = newValue,
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
        labelText: "Country",
        hintText: "Please enter Your Country",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Parcel.svg"),
      ),
    );
  }

  void _dropDownItemSelected(String? newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected.toString();
    });
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
  //

}
