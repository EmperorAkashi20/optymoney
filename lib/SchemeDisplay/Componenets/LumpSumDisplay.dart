import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:optymoney/SchemeDisplay/Componenets/body.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../size_config.dart';
import 'SipDisplay.dart';

addToCartRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/__lib.ajax/mutual_fund.php?action=add_cart_api&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var body = jsonEncode({
    "sch_code": Body.encodedIndex,
    "f_sip_amount": '',
    "sip_date": '0',
    "sch_d": Body.idIndex,
    "f_lum_amount": LumpSumDisplay.lumpsumAmount,
    "uid": SignForm.userIdGlobal,
  });
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  print(response.body);
}

class LumpSumDisplay extends StatefulWidget {
  static var ignoreButton = false;
  static var date;
  static var lumpsumAmount;

  @override
  _LumpSumDisplayState createState() => _LumpSumDisplayState();
}

class _LumpSumDisplayState extends State<LumpSumDisplay> {
  Timer? _timer;
  late double _progress;
  double miniamt = Body.minAmt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Please Use the slider to adjust the installment amount',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SfSlider(
                      enableTooltip: true,
                      activeColor: kPrimaryColor,
                      min: Body.lumpSumMin,
                      max: Body.lumpSumMax,
                      value: miniamt.toDouble(),
                      onChanged: (dynamic value) {
                        setState(() {
                          miniamt = value;
                        });
                      },
                    ),
                  ],
                ),
                GlobalOutputField(
                  outputValue: miniamt.toStringAsFixed(2),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IncrementButton(
                        amount: '1000',
                        press: () {
                          setState(() {
                            miniamt = (miniamt + 1000).toDouble();
                          });
                        },
                      ),
                      IncrementButton(
                        amount: '3000',
                        press: () {
                          setState(() {
                            miniamt = (miniamt + 3000).toDouble();
                          });
                        },
                      ),
                      IncrementButton(
                        amount: '5000',
                        press: () {
                          setState(() {
                            miniamt = (miniamt + 5000).toDouble();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                        ),
                        height: getProportionateScreenHeight(40),
                        width: getProportionateScreenWidth(140),
                        child: TextButton(
                          onPressed: () async {
                            LumpSumDisplay.lumpsumAmount = miniamt;

                            await addToCartRequest();
                            _progress = 0;
                            _timer?.cancel();
                            _timer =
                                Timer.periodic(const Duration(milliseconds: 10),
                                    (Timer timer) async {
                              await EasyLoading.showProgress(_progress,
                                  status:
                                      '${(_progress * 100).toStringAsFixed(0)}%');
                              _progress += 0.03;
                              if (_progress >= 1) {
                                _timer?.cancel();
                                EasyLoading.dismiss();
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_basket_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "ADD TO CART",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
