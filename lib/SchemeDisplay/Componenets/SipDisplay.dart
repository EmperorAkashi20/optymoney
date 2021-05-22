import 'package:flutter/material.dart';
import 'package:optymoney/SchemeDisplay/Componenets/body.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../size_config.dart';

class SipDisplay extends StatefulWidget {
  static var ignoreButton = false;
  @override
  _SipDisplayState createState() => _SipDisplayState();
}

class _SipDisplayState extends State<SipDisplay> {
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
                      min: Body.minAmt,
                      max: Body.maxAmt,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded),
                            Text('SIP DATE'),
                          ],
                        ),
                      )
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

class IncrementButton extends StatelessWidget {
  const IncrementButton({
    required this.amount,
    required this.press,
    Key? key,
  }) : super(key: key);

  final String amount;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(90),
        child: IgnorePointer(
          ignoring: SipDisplay.ignoreButton,
          child: TextButton(
            child: Text(
              "+₹" + amount,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            onPressed: press as void Function()?,
          ),
        ),
      ),
    );
  }
}
