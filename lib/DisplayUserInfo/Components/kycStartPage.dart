import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/Components/body.dart';

import '../../constants.dart';
import '../../size_config.dart';

makeOnboardRequest() async {
  var url = Uri.parse('https://multi-channel.signzy.tech/api/channels/login');
  final headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({
    "username": 'icici_OPTYmoney_prod',
    "password": 'Ld38M*9HS@rZs9nc#eK\$2OcQ6%D',
  });
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );
  var parsedJson = json.decode(response.body);
  KycStartPage.id = parsedJson['id'];
  KycStartPage.ttl = parsedJson['ttl'];
  KycStartPage.created = parsedJson['created'];
  KycStartPage.userId = parsedJson['userId'];
  //print(response.body);
  // print(KycStartPage.id);
  // print(KycStartPage.ttl);
  // print(KycStartPage.created);
  // print(KycStartPage.userId);
}

onBoardingProcess() async {
  var url = Uri.parse('https://multi-channel.signzy.tech/api/channels/' +
      KycStartPage.userId +
      '/onboardings');
  print(KycStartPage.id);
  print(KycStartPage.userId);
  print(url);

  var body = jsonEncode({
    "email": SignForm.email1,
    "username": KycStartPage.kycTodayUn,
    "phone": Body.custMobile,
    "name": SignForm.name,
    "redirectUrl":
        'https://optymoney.com/mySaveTax/?module_interface=a3ljX29uYm9hcmQ=',
    "channelEmail": "support@optymoney.com"
  });
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Authorization': '$KycStartPage.id',
      //HttpHeaders.authorizationHeader: '$KycStartPage.id'
    },
    body: body,
    encoding: encoding,
  );
  print(response.body);
  var parsedJson = json.decode(response.body);
  print(parsedJson);
  KycStartPage.test = parsedJson;
}

class KycStartPage extends StatefulWidget {
  static String routeName = '\kyc';
  static var id;
  static var ttl;
  static var created;
  static var userId;
  static var kycTodayDateTime;
  static var kycTodayUn;
  static var kycData;
  static var test;
  static var test1;
  const KycStartPage({Key? key}) : super(key: key);

  @override
  _KycStartPageState createState() => _KycStartPageState();
}

class _KycStartPageState extends State<KycStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Details'),
      ),
      drawer: AppDrawerMain(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TitleHeader(text: 'Name'),
                GlobalOutputField(outputValue: SignForm.name),
                TitleHeader(text: 'PAN'),
                GlobalOutputField(outputValue: SignForm.pan),
                TitleHeader(text: 'Mobile Number'),
                GlobalOutputField(outputValue: Body.custMobile),
                TitleHeader(text: 'EMail Address'),
                GlobalOutputField(outputValue: SignForm.email1),
                Text(
                  KycStartPage.test1.toString(),
                  style: TextStyle(color: kPrimaryColor, fontSize: 14),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              height: getProportionateScreenHeight(50),
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  var now = DateTime.now();

                  KycStartPage.kycTodayDateTime = (now.day.toString() +
                      now.month.toString() +
                      now.year.toString() +
                      now.hour.toString() +
                      now.minute.toString() +
                      now.second.toString());
                  KycStartPage.kycTodayUn = "opty_" +
                      SignForm.name
                          .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                          .toLowerCase() +
                      "_" +
                      KycStartPage.kycTodayDateTime.toString();
                  KycStartPage.kycData = SignForm.email1 +
                      KycStartPage.kycTodayUn +
                      Body.custMobile +
                      SignForm.name +
                      'support@optymoney.com';
                  print(KycStartPage.kycTodayUn);

                  await makeOnboardRequest();
                  if (KycStartPage.id != null) {
                    await onBoardingProcess();
                  } else {
                    throw 'Something went wrong';
                  }
                  setState(() {
                    KycStartPage.test1 = KycStartPage.test;
                  });
                },
                child: Center(
                  child: Text(
                    'Proceed',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
