import 'package:flutter/material.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AllSchemeDisplay.dart';
import 'package:optymoney/SchemeDisplay/Componenets/body.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../constants.dart';
import '../../models.dart';
import '../../size_config.dart';

class SipDisplayFilters extends StatefulWidget {
  static var ignoreButton = false;
  @override
  _SipDisplayFiltersState createState() => _SipDisplayFiltersState();
}

class _SipDisplayFiltersState extends State<SipDisplayFilters> {
  var _options = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
  ];
  String _currentItemSelected = '1';
  double miniamt = AllSchemeDisplay.minAmt;
  String _prefix = 'st';
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
                      min: AllSchemeDisplay.minAmt,
                      max: AllSchemeDisplay.maxAmt,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded),
                                SizedBox(width: 3),
                                Text('SIP DATE'),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: getProportionateScreenWidth(70),
                                  height: getProportionateScreenHeight(40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: kPrimaryColor, width: 1),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: Colors.grey.shade200,
                                      isExpanded: true,
                                      elevation: 0,
                                      items: _options
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                dropDownStringItem,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Divider(
                                                thickness: 0.4,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValueSelected) {
                                        _dropDownItemSelected(newValueSelected);
                                        if (_currentItemSelected == '1' ||
                                            _currentItemSelected == '21') {
                                          _prefix = 'st';
                                        } else if (_currentItemSelected ==
                                                '2' ||
                                            _currentItemSelected == '22') {
                                          _prefix = 'nd';
                                        } else if (_currentItemSelected ==
                                                '3' ||
                                            _currentItemSelected == '23') {
                                          _prefix = 'rd';
                                        } else {
                                          _prefix = 'th';
                                        }
                                      },
                                      value: _currentItemSelected,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(_prefix + ' of Every Month'),
                              ],
                            ),
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

  void _dropDownItemSelected(String? newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected.toString();
    });
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
          ignoring: SipDisplayFilters.ignoreButton,
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
