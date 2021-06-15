import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/DisplayUserInfo/Components/kycStartPage.dart';
import 'package:optymoney/OtherDetails/Components/OtherDetails.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  makeUserRequest() async {
    var url = Uri.parse(
        'https://optymoney.com/ajax-request/ajax_response.php?action=settinginfoapp&subaction=submit');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'cust_name': nameController,
      'birthday': bdayController,
      'sex': OtherDetailsForm.sex,
      'aadhar_num': aadharController,
      'nominee': nomieeController,
      'line1': address1Controller,
      'line2': address2Controller,
      'line3': address3Controller,
      'city': cityController,
      'state': stateController,
      'pincode': pinCodeController,
      'country': countryController,
      'r_of_nominee_w_app': relationWithController,
      'uid': SignForm.userIdGlobal,
    };
    //String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print(body);

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print(response.body);
  }

  bool enableNow = false;
  Color disabledColor = Colors.grey;
  Color stringColorSave = Colors.grey.shade600;
  Color stringColorEdit = kPrimaryColor;
  TextEditingController nameController = new TextEditingController();
  TextEditingController address1Controller = new TextEditingController();
  TextEditingController address2Controller = new TextEditingController();
  TextEditingController address3Controller = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController pinCodeController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController bdayController = new TextEditingController();
  TextEditingController nomieeController = new TextEditingController();
  TextEditingController relationWithController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Profile"),
      ),
      drawer: AppDrawerMain(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          SignForm.email1,
                          style: TextStyle(color: Colors.black),
                        ),
                        if (SignForm.kycStatus == 'success')
                          Text(
                            'KYC Compliant',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        if (SignForm.kycStatus != 'success')
                          Text(
                            'Please complete your KYC',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: Text(
                        SignForm.letter,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TitleHeader(text: "NAME"),
              FormFieldDisplayProfile(
                //dataController: nameController,
                initValue: SignForm.name,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Please enter your name',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "D.O.B"),
              FormFieldDisplayProfile(
                // dataController: bdayController,
                initValue: SignForm.userBday,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Please enter your bday',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Address"),
              FormFieldDisplayProfile(
                // dataController: address1Controller,
                initValue: SignForm.userAddress1,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Address Line 1',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                // dataController: address2Controller,
                initValue: SignForm.userAddress2,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Address Line 2',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                // dataController: address3Controller,
                initValue: SignForm.userAddress3,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Address Line 3',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                // dataController: cityController,
                initValue: SignForm.userCity,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'City',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                // dataController: stateController,
                initValue: SignForm.userState,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'State',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                // dataController: pinCodeController,
                initValue: SignForm.userPinCode,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Pin Code',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                // dataController: countryController,
                initValue: SignForm.userCountry,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Country',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Mobile Number"),
              FormFieldDisplayProfile(
                // dataController: mobileController,
                initValue: SignForm.userMobile,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Mobile Number',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "PAN"),
              FormFieldDisplayProfile(
                // dataController: panController,
                initValue: SignForm.pan,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Pan',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "AADHAR"),
              FormFieldDisplayProfile(
                // dataController: aadharController,
                initValue: SignForm.aadhar,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Aadhar Number',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Nominee Name"),
              FormFieldDisplayProfile(
                // dataController: nomieeController,
                initValue: SignForm.nomineeName,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Nominee Name',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Relation with Nominee"),
              FormFieldDisplayProfile(
                // dataController: relationWithController,
                initValue: SignForm.nomineeRelation,
                onChange: (value) => value,
                enabledOrNot: enableNow,
                hintText: 'Relation With Nominee',
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              if (SignForm.kycStatus != 'success')
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, KycStartPage.routeName);
                  },
                  child: Text('KYC Onboarding'),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: stringColorEdit,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        enableNow = true;
                        disabledColor = Colors.black87;
                        stringColorSave = kPrimaryColor;
                        stringColorEdit = Colors.grey;
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: stringColorSave,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        enableNow = false;
                        disabledColor = Colors.grey;
                        stringColorSave = Colors.grey.shade600;
                        stringColorEdit = kPrimaryColor;
                      });
                      await makeUserRequest();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
