import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/Components/body.dart';
import 'package:url_launcher/url_launcher.dart';

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

  var body = jsonEncode({
    "email": SignForm.email1.toString(),
    "username": KycStartPage.kycTodayUn.toString(),
    "phone": Body.custMobile.toString(),
    "name": SignForm.name.toString(),
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
      'Authorization': KycStartPage.id.toString(),
    },
    body: body,
    encoding: encoding,
  );
  var parsedJson = json.decode(response.body);
  var mobUrl = (parsedJson['createdObj']['mobileAutoLoginUrl']);
  if (await canLaunch(mobUrl)) {
    launch(mobUrl);
  } else {
    throw 'Unable to launch $mobUrl';
  }
}

getDataFunction() {
  var now = DateTime.now();

  KycStartPage.kycTodayDateTime = (now.day.toString() +
      now.month.toString() +
      now.year.toString() +
      now.hour.toString() +
      now.minute.toString() +
      now.second.toString());
  KycStartPage.kycTodayUn = "opty_" +
      SignForm.name.replaceAll(new RegExp(r"\s+\b|\b\s"), "").toLowerCase() +
      "_" +
      KycStartPage.kycTodayDateTime.toString();
  KycStartPage.kycData = SignForm.email1 +
      KycStartPage.kycTodayUn +
      Body.custMobile +
      SignForm.name +
      'support@optymoney.com';
  print(KycStartPage.kycTodayUn);
  print(KycStartPage.kycData);
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
                  await getDataFunction();
                  await makeOnboardRequest();
                  if (KycStartPage.id != null) {
                    await onBoardingProcess();
                  } else {
                    throw 'Something went wrong';
                  }
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
