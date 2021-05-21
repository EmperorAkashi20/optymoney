import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:url_launcher/url_launcher.dart';

const _url = 'https://flutter.dev';

makeKycRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=kyccheck_api&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
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

  Body.responseBody = response.body;
  Body.parsed = json.decode(Body.responseBody);
  Body.status = Body.parsed['status'].toString();
  print(Body.status);
}

class Body extends StatefulWidget {
  static var responseBody;
  static var parsed;
  static var status;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    makeKycRequest();
  }

  bool enableNow = false;
  Color disabledColor = Colors.grey;
  Color stringColorSave = Colors.grey.shade600;
  Color stringColorEdit = kPrimaryColor;
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
                          SignForm.name,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          SignForm.email1,
                          style: TextStyle(color: Colors.black),
                        ),
                        if (Body.status == 'success')
                          Text(
                            'KYC Compliant',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        if (Body.status != 'success')
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
              TitleHeader(text: "D.O.B"),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userBday,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Address"),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userAddress1,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userAddress2,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userAddress3,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userCity,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userState,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userPinCode,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userCountry,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Mobile Number"),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userMobile,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              if (Body.status != 'success')
                TextButton(onPressed: _launchURL, child: Text('Launch')),
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
                    onPressed: () {
                      setState(() {
                        enableNow = false;
                        disabledColor = Colors.grey;
                        stringColorSave = Colors.grey.shade600;
                        stringColorEdit = kPrimaryColor;
                      });
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

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
