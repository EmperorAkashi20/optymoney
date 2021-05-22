import 'package:flutter/material.dart';
import 'package:optymoney/SchemeDisplay/Componenets/body.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../size_config.dart';
import 'SipDisplay.dart';

class LumpSumDisplay extends StatefulWidget {
  @override
  _LumpSumDisplayState createState() => _LumpSumDisplayState();
}

class _LumpSumDisplayState extends State<LumpSumDisplay> {
  double miniamt = Body.lumpSumMin;

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
                          onPressed: () {},
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
