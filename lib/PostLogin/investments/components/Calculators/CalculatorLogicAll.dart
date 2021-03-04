import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../constants.dart';
import '../../../../models.dart';
import '../../../../size_config.dart';

//-------------------------------------------------------------------------------------SIP CALCULATOR------------------------------------------------------------------------------------------------------------
class SipCalcFrom extends StatefulWidget {
  @override
  _SipCalcFromState createState() => _SipCalcFromState();
}

class _SipCalcFromState extends State<SipCalcFrom> {
  var _options = ['Yes', 'No'];
  var _currentItemSelected = 'Yes';

  TextEditingController sip1Amount = new TextEditingController();
  TextEditingController investedFor = new TextEditingController();
  TextEditingController expectedRateOfReturn = new TextEditingController();
  TextEditingController inflationRate = new TextEditingController();

  String amountInvested = "0";
  String futureValueOfInvestment = "0";

  var sipAmount = 0.0;
  var noOfYrs = 0.0;
  var r = 0.0;
  var i = 0.0;
  var returnRate = 0.0;
  var inflationRateController = 0.0;
  var investedAmount = 0.0;
  var a = 0.0;
  var b = 0.0;
  var realReturn = 0.0;
  var c = 0.0;
  var nominalRate = 0.0;
  var d = 0.0;
  var nominalRate1 = 0.0;
  var fv1 = 0.0;
  var fvInvestmentDouble = 0.0;
  var fvInvestmentInt = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "SIP Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(
                text: "SIP Amount", richText: " (Minimum Rs. 500/-)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Invested Monthly",
              dataController: sip1Amount,
            ),
            TitleHeaderWithRichText(text: "Invested For", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "No. Of Years",
              dataController: investedFor,
            ),
            TitleHeaderWithRichText(
              text: "Expected Rate Of Return",
              richText: " (%)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: expectedRateOfReturn,
            ),
            TitleHeader(text: "Adjust For Inflation?"),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            TitleHeaderWithRichText(text: "Inflation Rate", richText: " (%)"),
            FormFieldGlobal(
              enabledOrNot: true,
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: inflationRate,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        if (_currentItemSelected == 'No') {
                          i = 0;
                          inflationRateController = 0;
                        } else if (_currentItemSelected == 'Yes') {
                          i = double.tryParse(inflationRate.text);
                        }
                        if (inflationRate.text.isEmpty) {
                          i = 0;
                        }
                        sipAmount = double.tryParse(sip1Amount.text);
                        noOfYrs = double.tryParse(investedFor.text);
                        r = double.tryParse(expectedRateOfReturn.text);
                        inflationRateController = i / 100;
                        returnRate = r / 100;
                        investedAmount = sipAmount * (noOfYrs * 12);
                        a = (1 + returnRate);
                        b = (1 + inflationRateController);
                        realReturn = ((a / b) - 1);
                        c = pow((1 + realReturn), (1 / (noOfYrs * 12)));
                        nominalRate = noOfYrs * (c - 1);
                        d = pow((1 + nominalRate), (noOfYrs * 12));
                        nominalRate1 = (1 + nominalRate);
                        fv1 = sipAmount * (nominalRate1) / nominalRate;
                        fvInvestmentDouble = (d * fv1) - fv1;
                        amountInvested = investedAmount.toString();
                        fvInvestmentInt = fvInvestmentDouble.round();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Amount Invested"),
            GlobalOutputField(
              outputValue: amountInvested,
            ),
            TitleHeader(text: "Future Value Investment Of"),
            GlobalOutputField(
              outputValue: fvInvestmentInt.toString(),
            ),
            SuggestionBox1(
              suggestion: "If you invest ₹" +
                  sipAmount.toString() +
                  " per month for " +
                  noOfYrs.toString() +
                  " years @ " +
                  r.toString() +
                  " % P.A expected rate of return, you will accumulate ₹" +
                  fvInvestmentInt.toString() +
                  " at the end of the " +
                  noOfYrs.toString() +
                  " years.",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------SIP CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------EMI CAR LOAN CALCULATOR------------------------------------------------------------------------------------------------------------
class EmiCarLoanCalcForm extends StatefulWidget {
  @override
  _EmiCarLoanCalcFormState createState() => _EmiCarLoanCalcFormState();
}

class _EmiCarLoanCalcFormState extends State<EmiCarLoanCalcForm> {
  TextEditingController carLoanAmount = new TextEditingController();
  TextEditingController tenure = new TextEditingController();
  TextEditingController interestRate = new TextEditingController();

  String emiAmount = "0";
  String totalAmountPayable = "0";
  String interestAmount = "0";

  var p;
  var r;
  var n;
  var emi;
  var totalPayAmt;
  var totalPayInt;
  var x;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "EMI Car Loan Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Car Loan Amount"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: carLoanAmount,
            ),
            TitleHeaderWithRichText(text: "Interest Rate", richText: " (P.A.)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: interestRate,
            ),
            TitleHeaderWithRichText(text: "Tenure", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Time Here",
              dataController: tenure,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        p = double.tryParse(carLoanAmount.text);
                        r = double.tryParse(interestRate.text) / 100 / 12;
                        n = double.tryParse(tenure.text) * 12;
                        x = pow((1 + r), n);
                        emi = ((p * x * r) / (x - 1));
                        totalPayAmt = ((emi * n));
                        totalPayInt = totalPayAmt - p;
                        emiAmount = (emi.round()).toString();
                        totalAmountPayable = (totalPayAmt.round()).toString();
                        interestAmount = (totalPayInt.round()).toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "EMI Amount"),
            GlobalOutputField(
              outputValue: emiAmount,
            ),
            TitleHeader(text: "Total Payable Amount"),
            GlobalOutputField(
              outputValue: totalAmountPayable,
            ),
            TitleHeader(text: "Interest Amount"),
            GlobalOutputField(
              outputValue: interestAmount,
            ),
            SuggestionBox1(
              suggestion:
                  "Keep your loan tenure as low as possible, as the tenure increases interest component increases significantly.",
            ),
            SuggestionBox2(
              suggestion: "* Invest in SIP's to reach your car goal ",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}
//-------------------------------------------------------------------------------------EMI CAR LOAN CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------EMI HOME LOAN CALCULATOR------------------------------------------------------------------------------------------------------------

class EmiHomeLoanCalcForm extends StatefulWidget {
  @override
  _EmiHomeLoanCalcFormState createState() => _EmiHomeLoanCalcFormState();
}

class _EmiHomeLoanCalcFormState extends State<EmiHomeLoanCalcForm> {
  TextEditingController homeLoanAmount = new TextEditingController();
  TextEditingController tenure = new TextEditingController();
  TextEditingController interestRate = new TextEditingController();

  String emiAmount = "0";
  String totalAmountPayable = "0";
  String interestAmount = "0";

  var p;
  var r;
  var n;
  var emi;
  var totalPayAmt;
  var totalPayInt;
  var x;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "EMI Home Loan Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Housing Loan Amount"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: homeLoanAmount,
            ),
            TitleHeaderWithRichText(text: "Interest Rate", richText: " (P.A.)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: interestRate,
            ),
            TitleHeaderWithRichText(text: "Tenure", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Time Here",
              dataController: tenure,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        p = double.tryParse(homeLoanAmount.text);
                        r = double.tryParse(interestRate.text) / 100 / 12;
                        n = double.tryParse(tenure.text) * 12;
                        x = pow((1 + r), n);
                        emi = ((p * x * r) / (x - 1));
                        totalPayAmt = ((emi * n));
                        totalPayInt = totalPayAmt - p;
                        emiAmount = (emi.round()).toString();
                        totalAmountPayable = (totalPayAmt.round()).toString();
                        interestAmount = (totalPayInt.round()).toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "EMI Amount"),
            GlobalOutputField(
              outputValue: emiAmount,
            ),
            TitleHeader(text: "Total Payable Amount"),
            GlobalOutputField(
              outputValue: totalAmountPayable,
            ),
            TitleHeader(text: "Interest Amount"),
            GlobalOutputField(
              outputValue: interestAmount,
            ),
            SuggestionBox1(
              suggestion:
                  "Keep your loan tenure as low as possible, as the tenure increases interest component increases significantly.",
            ),
            SuggestionBox2(
              suggestion: "* Invest in SIP's to reach your house goal ",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------EMI HOME LOAN CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------EMI PERSONAL LOAN CALCULATOR------------------------------------------------------------------------------------------------------------

class EmiPersonalLoanCalcForm extends StatefulWidget {
  @override
  _EmiPersonalLoanCalcFormState createState() =>
      _EmiPersonalLoanCalcFormState();
}

class _EmiPersonalLoanCalcFormState extends State<EmiPersonalLoanCalcForm> {
  TextEditingController personalLoanAmount = new TextEditingController();
  TextEditingController tenure = new TextEditingController();
  TextEditingController interestRate = new TextEditingController();

  String emiAmount = "0";
  String totalAmountPayable = "0";
  String interestComponent = "0";

  var p;
  var r;
  var n;
  var emi;
  var totalPayAmt;
  var totalPayInt;
  var x;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "EMI Personal Loan Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Housing Loan Amount"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: personalLoanAmount,
            ),
            TitleHeaderWithRichText(text: "Interest Rate", richText: " (P.A.)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: interestRate,
            ),
            TitleHeaderWithRichText(text: "Tenure", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Time Here",
              dataController: tenure,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        p = double.tryParse(personalLoanAmount.text);
                        r = double.tryParse(interestRate.text) / 100 / 12;
                        n = double.tryParse(tenure.text) * 12;
                        x = pow((1 + r), n);
                        emi = ((p * x * r) / (x - 1));
                        totalPayAmt = ((emi * n));
                        totalPayInt = totalPayAmt - p;
                        emiAmount = (emi.round()).toString();
                        totalAmountPayable = (totalPayAmt.round()).toString();
                        interestComponent = (totalPayInt.round()).toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "EMI Amount"),
            GlobalOutputField(
              outputValue: emiAmount,
            ),
            TitleHeader(text: "Total Payable Amount"),
            GlobalOutputField(
              outputValue: totalAmountPayable,
            ),
            TitleHeader(text: "Interest Amount"),
            GlobalOutputField(
              outputValue: interestComponent,
            ),
            SuggestionBox1(
              suggestion:
                  "Keep your loan tenure as low as possible, as the tenure increases interest component increases significantly.",
            ),
            SuggestionBox2(
              suggestion:
                  "* Invest in SIP's for emergency fund with instant withdraw option ",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------EMI PERSONAL LOAN CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------SWP CALCULATOR------------------------------------------------------------------------------------------------------------

class SwpCalcForm extends StatefulWidget {
  @override
  _SwpCalcFormState createState() => _SwpCalcFormState();
}

class _SwpCalcFormState extends State<SwpCalcForm> {
  TextEditingController totalAmountInvested = new TextEditingController();
  TextEditingController withdrawalPerMonth = new TextEditingController();
  TextEditingController expectedReturn = new TextEditingController();
  TextEditingController tenure = new TextEditingController();

  String valueAtTheEnd = "0";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "SWP Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Total Investment Amount"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: totalAmountInvested,
            ),
            TitleHeader(text: "Withdrawal Per Month"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: withdrawalPerMonth,
            ),
            TitleHeader(text: "Expected Return"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: expectedReturn,
            ),
            TitleHeaderWithRichText(
              text: "Tenure",
              richText: " (Years)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Years",
              dataController: tenure,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Value At The End Of Tenure"),
            GlobalOutputField(
              outputValue: valueAtTheEnd,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------SWP CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------LUMP SUM CALCULATOR------------------------------------------------------------------------------------------------------------

class LumpSumCalcFrom extends StatefulWidget {
  @override
  _LumpSumCalcFromState createState() => _LumpSumCalcFromState();
}

class _LumpSumCalcFromState extends State<LumpSumCalcFrom> {
  var _options = ['Yes', 'No'];
  var _currentItemSelected = 'Yes';

  TextEditingController lumpSumAmount = new TextEditingController();
  TextEditingController investedFor = new TextEditingController();
  TextEditingController expectedRateOfReturn = new TextEditingController();
  TextEditingController inflationRate = new TextEditingController();

  String amountInvested = "0";
  String futureValueOfInvestment = "0";

  var requiredAmt = 0.0;
  var noOfYrs = 0.0;
  var r = 0.0;
  var i = 0.0;
  var returnRate = 0.0;
  var inflationRateController = 0.0;
  var a = 0.0;
  var b = 0.0;
  var realReturn = 0.0;
  var fv = 0.0;
  var fvInt = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Lump Sum Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(
                text: "LumpSum Amount Invested", richText: " "),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Invested Monthly",
              dataController: lumpSumAmount,
            ),
            TitleHeaderWithRichText(text: "Time Period", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "No. Of Years",
              dataController: investedFor,
            ),
            TitleHeaderWithRichText(
              text: "Expected Rate Of Return",
              richText: " (%)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: expectedRateOfReturn,
            ),
            TitleHeader(text: "Adjust For Inflation?"),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            TitleHeaderWithRichText(text: "Inflation Rate", richText: " (%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: inflationRate,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        if (_currentItemSelected == 'No') {
                          i = 0;
                          inflationRateController = 0;
                        } else if (_currentItemSelected == 'Yes') {
                          i = double.tryParse(inflationRate.text);
                        }
                        if (inflationRate.text.isEmpty) {
                          i = 0;
                        }
                        requiredAmt = double.tryParse(lumpSumAmount.text);
                        noOfYrs = double.tryParse(investedFor.text);
                        r = double.tryParse(expectedRateOfReturn.text);
                        i = double.tryParse(inflationRate.text);
                        returnRate = r / 100;
                        inflationRateController = i / 100;
                        a = 1 + returnRate;
                        b = 1 + inflationRateController;
                        realReturn = (a / b) - 1;
                        fv = (requiredAmt * pow((1 + realReturn), (noOfYrs)));
                        fvInt = fv.round();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Amount Invested"),
            GlobalOutputField(
              outputValue: requiredAmt.toString(),
            ),
            TitleHeader(text: "Future Value Of Investment"),
            GlobalOutputField(
              outputValue: fvInt.toString(),
            ),
            SuggestionBox1(
              suggestion: "If you invest ₹" +
                  requiredAmt.toString() +
                  "per month for " +
                  noOfYrs.toString() +
                  "years @ " +
                  r.toString() +
                  "% P.A expected rate of return, you will accumulate ₹" +
                  fvInt.toString() +
                  " at the end of " +
                  noOfYrs.toString() +
                  " years.",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------LUMP SUM CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------HRA CALCULATOR------------------------------------------------------------------------------------------------------------

class HraCalcFrom extends StatefulWidget {
  @override
  _HraCalcFromState createState() => _HraCalcFromState();
}

class _HraCalcFromState extends State<HraCalcFrom> {
  var _options = ['Delhi', 'Mumbai', 'Kolkata', 'Chennai', 'Other'];

  TextEditingController basicSalaryReceived = new TextEditingController();
  TextEditingController dearnessAllowanceReceived = new TextEditingController();
  TextEditingController hraReceived = new TextEditingController();
  TextEditingController actualRentPaid = new TextEditingController();

  String hraExemption = "0";
  String hraTaxable = "0";

  var salRec = 0.0;
  var da = 0.0;
  var hraRec = 0.0;
  var rentPaid = 0.0;
  var city;
  var metroNoMetro = 0.0;
  var _currentItemSelected = 'Delhi';
  var hraTax = 0.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "HRA Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(
                text: "Basic Salary Received", richText: " "),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: basicSalaryReceived,
            ),
            TitleHeaderWithRichText(
                text: "Dearness Allowance(DA) Received", richText: " "),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: dearnessAllowanceReceived,
            ),
            TitleHeaderWithRichText(
              text: "HRA Received",
              richText: " ",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: hraReceived,
            ),
            TitleHeaderWithRichText(
              text: "Actual Rent Paid",
              richText: " ",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: actualRentPaid,
            ),
            TitleHeader(text: "Select City"),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        salRec = double.tryParse(basicSalaryReceived.text);
                        da = double.tryParse(dearnessAllowanceReceived.text);
                        hraRec = double.tryParse(hraReceived.text);
                        rentPaid = double.tryParse(actualRentPaid.text);
                        rentPaid = (rentPaid - ((salRec + da) * (10 / 100)));
                        city = _currentItemSelected;
                        if (city == 'Other') {
                          metroNoMetro = (((salRec + da)) * (40 / 100));
                        } else {
                          metroNoMetro = (((salRec + da)) * (50 / 100));
                        }
                        // var list = [hraReceived, rentPaid, metroNoMetro];
                        // list.sort();
                        if (hraRec < rentPaid && hraRec < metroNoMetro) {
                          hraExemption = hraRec.toString();
                        } else if (rentPaid < hraRec &&
                            rentPaid < metroNoMetro) {
                          hraExemption = rentPaid.toString();
                        } else if (metroNoMetro < hraRec &&
                            metroNoMetro < rentPaid) {
                          hraExemption = metroNoMetro.toString();
                        }
                        hraTax = (hraRec - double.tryParse(hraExemption));
                        hraTaxable = hraTax.toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "HRA Exemption"),
            GlobalOutputField(
              outputValue: hraExemption,
            ),
            TitleHeader(text: "HRA Taxable"),
            GlobalOutputField(
              outputValue: hraTaxable,
            ),
            SuggestionBox1(
              suggestion: "Invest in Tax saving mutual funds for saving TAX ",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------HRA CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------PPF CALCULATOR------------------------------------------------------------------------------------------------------------

class PpfCalcFrom extends StatefulWidget {
  @override
  _PpfCalcFromState createState() => _PpfCalcFromState();
}

class _PpfCalcFromState extends State<PpfCalcFrom> {
  var _options = ['End Of Period', 'Beginning Of Period'];
  var _currentItemSelected = 'End Of Period';

  TextEditingController totalAmountInvested = new TextEditingController();
  TextEditingController ppfInterestRate = new TextEditingController();
  TextEditingController tenure = new TextEditingController();

  String totalInvestment = "0";
  String totalInterestEarned = "0";
  String totalMaturityAmount = "0";

  var principal;
  var rateType;
  var time;
  var ppfTotalMatAmt;
  var selected;
  var amt;
  var totalInvestment1;
  var interestEarned;

  double clcPPF(principalVal, intRate, years) {
    var amt = 0.00;
    for (var i = 1; i <= years; i++) {
      var show = '';
      if (i >= 1 && i <= 15) {
        amt = (amt + principalVal);
      }
      if (intRate == 7.6 && i == years) {
      } else {
        amt = amt + (amt * intRate) / 100;
      }
    }
    return amt;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "PPF Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(
                text: "PPF Interest Rate", richText: " (%)"),
            GlobalOutputField(
              outputValue: rateType.toString(),
            ),
            TitleHeaderWithRichText(
                text: "Amount Invested", richText: " (Per Year)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: totalAmountInvested,
            ),
            TitleHeader(text: "No Of Years"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Time Here",
              dataController: tenure,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        principal = double.tryParse(totalAmountInvested.text);
                        time = double.tryParse(tenure.text);
                        selected = _currentItemSelected;
                        if (selected == 'End Of Period') {
                          rateType = 7.6;
                        } else if (selected == 'Beginning Of Period') {
                          rateType = 7.8;
                        }
                        if (rateType == 7.6) {
                          ppfTotalMatAmt = clcPPF(principal, rateType, time);
                        } else if (rateType == 7.8) {
                          ppfTotalMatAmt = clcPPF(principal, rateType, time);
                        }
                        totalInvestment1 = (principal * time);
                        interestEarned = ppfTotalMatAmt - totalInvestment1;
                        totalMaturityAmount = ppfTotalMatAmt.round().toString();
                        totalInvestment = totalInvestment1.round().toString();
                        totalInterestEarned = interestEarned.round().toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Total Investment"),
            GlobalOutputField(
              outputValue: totalInvestment,
            ),
            TitleHeader(text: "Total Interest Earned"),
            GlobalOutputField(
              outputValue: totalInterestEarned,
            ),
            TitleHeader(text: "Total Maturity Earned"),
            GlobalOutputField(
              outputValue: totalMaturityAmount,
            ),
            SuggestionBox1(suggestion: "Tax Saving Under Sex 80C,"),
            SuggestionBox2(
              suggestion:
                  "ELSS(Tax Saving MF) is also exempted like PPF and can generate better return then PPF ",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------PPF CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------SIP INSTALLMENT CALCULATOR------------------------------------------------------------------------------------------------------------

class SipInstallmentCalcForm extends StatefulWidget {
  @override
  _SipInstallmentCalcFormState createState() => _SipInstallmentCalcFormState();
}

class _SipInstallmentCalcFormState extends State<SipInstallmentCalcForm> {
  var _options = ['Low - 7%', 'Medium - 12%', 'High - 15%'];
  var _currentItemSelected = 'High - 15%';

  TextEditingController amountYouWantToAchieve = new TextEditingController();
  TextEditingController withinNumberOfYears = new TextEditingController();
  TextEditingController rateOfReturn = new TextEditingController();

  String monthlySipInvestmentNeeded = "0";

  var requiredAmount;
  var noOfYrs;
  var r;
  var a;
  var b;
  var returnRate;
  var nominalRate;
  var sipAmount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "SIP Installment Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Amount You Want To Achieve"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: amountYouWantToAchieve,
            ),
            TitleHeader(text: "Within Number Of Years"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Time Here",
              dataController: withinNumberOfYears,
            ),
            TitleHeader(text: "Risk Undertaken"),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            TitleHeaderWithRichText(text: "Rate Of Return", richText: " (%)"),
            GlobalOutputField(
              outputValue: _currentItemSelected,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        requiredAmount =
                            double.tryParse(amountYouWantToAchieve.text);
                        noOfYrs = double.tryParse(withinNumberOfYears.text);
                        if (_currentItemSelected == 'Low - 7%') {
                          r = 7;
                        } else if (_currentItemSelected == 'Medium - 12%') {
                          r = 12;
                        } else if (_currentItemSelected == 'High - 15%') {
                          r = 15;
                        }
                        returnRate = r / 100;
                        a = pow((1 + returnRate), (1 / (noOfYrs * 12)));
                        nominalRate = noOfYrs * (a - 1);
                        b = (pow((1 + nominalRate), (noOfYrs * 12)));
                        sipAmount =
                            ((requiredAmount * nominalRate) / (b - 1)).round();
                        monthlySipInvestmentNeeded = sipAmount.toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Monthly Investment Required"),
            GlobalOutputField(
              outputValue: monthlySipInvestmentNeeded,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------SIP INSTALLMENT CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------FIXED DEPOSIT CALCULATOR------------------------------------------------------------------------------------------------------------

class FixedDepositCalcForm extends StatefulWidget {
  @override
  _FixedDepositCalcFormState createState() => _FixedDepositCalcFormState();
}

class _FixedDepositCalcFormState extends State<FixedDepositCalcForm> {
  var _options = ['Years', 'Months', 'Days'];
  var _currentItemSelected = 'Years';
  var _options2 = [
    'Simple Interest',
    'Monthly',
    'Quarterly',
    'Half Yearly',
    'Annually'
  ];
  var _currentItemSelected2 = 'Simple Interest';

  TextEditingController amountInvested = new TextEditingController();
  TextEditingController investedForNumberOf = new TextEditingController();
  TextEditingController interestRate = new TextEditingController();

  String maturityValue = "0";
  String interestEarned = "0";

  var principal;
  var rate3 = 0.0;
  var time;
  var timePeriod;
  var intType;
  var amt;
  var totalInt;

  double calcTime(time1) {
    var timePeriod;
    if (time1 == 1) {
      timePeriod = "years";
    } else if (time1 == 12) {
      timePeriod = "months";
    } else if (timePeriod == 365 || timePeriod == 366) {
      timePeriod = "days";
    }
    return timePeriod;
  }

  int calcTime1(time1) {
    var timePeriod;
    if (time1 == "Years") {
      timePeriod = 1;
    } else if (time1 == "Months") {
      timePeriod = 12;
    } else if (time1 == "Days" || time1 == "Days") {
      timePeriod = 365;
    }
    return timePeriod;
  }

  double clcSimpleInt(principal1, n, time1, rate, aa) {
    var rate2 = rate / 100;
    var amountInterest = principal1 * (1 + (rate2 / aa * time1));
    return amountInterest;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Fixed Deposit Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Amount Invested"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: amountInvested,
            ),
            TitleHeader(text: "Invested For Number Of"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: investedForNumberOf,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            TitleHeaderWithRichText(text: "Interest Rate", richText: " (%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: interestRate,
            ),
            TitleHeader(text: "Frequency"),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options2.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected2) {
                      _dropDownItemSelected2(newValueSelected2);
                    },
                    value: _currentItemSelected2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        principal = double.tryParse(amountInvested.text);
                        time = double.tryParse(investedForNumberOf.text);
                        rate3 = double.tryParse(interestRate.text);
                        intType = _currentItemSelected2;
                        var timePeriod3 = calcTime1(_currentItemSelected);
                        if (intType == 'Simple Interest') {
                          amt = clcSimpleInt(
                              principal, 1, time, rate3, timePeriod3);
                        } else {
                          amt = (principal *
                              pow((1 + (rate3 / (intType * 100))),
                                  (intType * time / timePeriod3)));
                        }
                        print(amt);
                        amt = amt.round();
                        totalInt = amt - principal.round();
                        var showTime = calcTime(timePeriod);
                        maturityValue = amt.toString();
                        interestEarned = totalInt.toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Maturity Value Of Investment"),
            GlobalOutputField(
              outputValue: maturityValue,
            ),
            TitleHeader(text: "Interest Earned"),
            GlobalOutputField(
              outputValue: interestEarned,
            ),
            SuggestionBox1(
              suggestion:
                  "If you invest Rs.***** per month for *** @ % P.A expected rate of return, you will accumulate Rs. **** at the end of the **.",
            ),
            SuggestionBox2(
              suggestion: "Earn More then FD's by Investing MF's",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  void _dropDownItemSelected2(String newValueSelected2) {
    setState(() {
      this._currentItemSelected2 = newValueSelected2;
    });
  }
}

//-------------------------------------------------------------------------------------FIXED DEPOSIT CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------SSJ CALCULATOR------------------------------------------------------------------------------------------------------------

class SukanyaSamriddhiCalcForm extends StatefulWidget {
  @override
  _SukanyaSamriddhiCalcFormState createState() =>
      _SukanyaSamriddhiCalcFormState();
}

class _SukanyaSamriddhiCalcFormState extends State<SukanyaSamriddhiCalcForm> {
  var _options = [
    'Years',
    'Months',
  ];
  var _currentItemSelected = 'Years';

  TextEditingController amountInvested = new TextEditingController();
  TextEditingController interestRate = new TextEditingController();
  TextEditingController investmentStartedAtTheAgeOf =
      new TextEditingController();

  String maturityYear = "0";
  String totalMaturityAmount = "0";

  var totalAmount;
  var monthType;
  var r;
  var startYear;
  var rate;
  var result;
  var maturityYearInt;

  double ssyCal(amount, rate, interestType) {
    var nper = 6;
    var rate1 = rate / interestType;
    var nper1 = 15 * interestType;
    var k1 = (1 + rate1);
    var rateMPow = pow((k1), (nper1));
    var fvM = amount * (k1) / rate1;
    var fvFinalM = (rateMPow * fvM) - fvM;
    var rateMPow1 = pow((1 + rate), (nper));
    var fv2M = rateMPow1 * fvFinalM;
    return (fv2M);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Sukanya Samriddhi Yojna",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Amount Invested"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: amountInvested,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            TitleHeaderWithRichText(text: "Interest Rate", richText: " (%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: interestRate,
            ),
            TitleHeader(text: "Investment Started At the Year Of"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Year Here",
              dataController: investmentStartedAtTheAgeOf,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        totalAmount = double.tryParse(amountInvested.text);
                        r = double.tryParse(interestRate.text);
                        startYear =
                            double.tryParse(investmentStartedAtTheAgeOf.text);
                        rate = r / 100;
                        maturityYearInt = (startYear + 15).round();
                        maturityYear = maturityYearInt.toString();
                        if (_currentItemSelected == 'Years') {
                          monthType = 1;
                        } else if (_currentItemSelected == 'Months') {
                          monthType = 12;
                        }
                        if (monthType == 12) {
                          result =
                              (ssyCal(totalAmount, rate, monthType)).round();
                        } else if (monthType == 1) {
                          result =
                              (ssyCal(totalAmount, rate, monthType)).round();
                        }
                        totalMaturityAmount = result.toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Maturity Year"),
            GlobalOutputField(
              outputValue: maturityYear,
            ),
            TitleHeader(text: "Total Maturity Amount"),
            GlobalOutputField(
              outputValue: totalMaturityAmount,
            ),
            SuggestionBox1(
              suggestion:
                  " Invest in top MF's for child education, child marriage and for bright future of child . ",
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------SSJ CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------RECURRING DEPOSIT CALCULATOR------------------------------------------------------------------------------------------------------------

class RecurringDepositCalcForm extends StatefulWidget {
  @override
  _RecurringDepositCalcFormState createState() =>
      _RecurringDepositCalcFormState();
}

class _RecurringDepositCalcFormState extends State<RecurringDepositCalcForm> {
  TextEditingController amountInvestedMonthly = new TextEditingController();
  TextEditingController investedForNoOfYears = new TextEditingController();
  TextEditingController interestRate = new TextEditingController();

  String maturityValue = "0";

  var monthlyInstallment;
  var numberOfYears;
  var rateOfInterest;
  var numberOfMonths;
  var amount;

  double clcRecurrInt(monthlyInstallment1, numberOfMonths1, rateOfInterest1) {
    var frequency = (numberOfMonths1 / 3).floor();
    var accumulateMonthlyAmount = monthlyInstallment1 *
        ((pow(rateOfInterest1 / 400 + 1, frequency) - 1) /
            (1 - (pow(rateOfInterest1 / 400 + 1, (-1 / 3)))));

    print(accumulateMonthlyAmount);
    var finalInterestGain =
        accumulateMonthlyAmount - monthlyInstallment * numberOfMonths;
    var depositedAmount = monthlyInstallment * numberOfMonths;
    return accumulateMonthlyAmount;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Recurring Deposit Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Amount Invested Monthly"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: amountInvestedMonthly,
            ),
            TitleHeaderWithRichText(text: "Invested For", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Years Here",
              dataController: investedForNoOfYears,
            ),
            TitleHeaderWithRichText(text: "Interest Rate", richText: " (%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: interestRate,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        monthlyInstallment =
                            double.tryParse(amountInvestedMonthly.text);
                        numberOfYears =
                            double.tryParse(investedForNoOfYears.text);
                        rateOfInterest = double.tryParse(interestRate.text);
                        numberOfMonths = numberOfYears * (12);
                        amount = (clcRecurrInt(monthlyInstallment,
                            numberOfMonths, rateOfInterest));
                        maturityValue = (amount.round()).toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Maturity Value"),
            GlobalOutputField(
              outputValue: maturityValue,
            ),
            SuggestionBox1(
                suggestion: " Earn More then RD's by Investing MF's "),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------RECURRING DEPOSIT CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------NPS CALCULATOR------------------------------------------------------------------------------------------------------------

class NpsCalcForm extends StatefulWidget {
  @override
  _NpsCalcFormState createState() => _NpsCalcFormState();
}

class _NpsCalcFormState extends State<NpsCalcForm> {
  TextEditingController currentAge = new TextEditingController();
  TextEditingController retirementAge = new TextEditingController();
  TextEditingController totalInvestingPeriod = new TextEditingController();
  TextEditingController monthlyContributionToBeDone =
      new TextEditingController();
  TextEditingController expectedRateOfReturn = new TextEditingController();

  String principalAmountInvested = "0";
  String interestEarnedOnInvestment = "0";
  String pensionWealthGenerated = "0";

  var currentAge1;
  var retirementAge1;
  var numberOfYears;
  var amount;
  var r;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "NPS Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(text: "Current Age", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Age Here",
              dataController: currentAge,
            ),
            TitleHeaderWithRichText(
                text: "Retirement Age", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Age Here",
              dataController: retirementAge,
            ),
            TitleHeaderWithRichText(
                text: "Total Investing Period", richText: " (Years)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Time Here",
              dataController: totalInvestingPeriod,
            ),
            TitleHeaderWithRichText(
                text: "Monthly Contribution To Be Done", richText: ""),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Years Here",
              dataController: monthlyContributionToBeDone,
            ),
            TitleHeaderWithRichText(
                text: "Expected Rate Of Return", richText: " (%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Years Here",
              dataController: expectedRateOfReturn,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        currentAge1 = double.tryParse(currentAge.text);
                        retirementAge1 = double.tryParse(retirementAge.text);
                        numberOfYears =
                            double.tryParse(totalInvestingPeriod.text);
                        amount =
                            double.tryParse(monthlyContributionToBeDone.text);
                        r = double.tryParse(expectedRateOfReturn.text);
                        var returnRate = (r / (1200));
                        var prinAmtInv = amount * numberOfYears * 12;
                        var d = pow((1 + returnRate), (numberOfYears * 12));
                        var returnRate1 = (1 + returnRate);
                        var fv1 = amount / returnRate;
                        var fvInvestment = (d * fv1) - fv1;
                        var intEarOnInvest = fvInvestment - prinAmtInv;

                        principalAmountInvested =
                            (prinAmtInv.round()).toString();
                        interestEarnedOnInvestment =
                            (intEarOnInvest.round()).toString();
                        pensionWealthGenerated =
                            (fvInvestment.round()).toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Principal Amount Invested"),
            GlobalOutputField(
              outputValue: principalAmountInvested,
            ),
            TitleHeader(text: "Interest Earned On Investment"),
            GlobalOutputField(
              outputValue: interestEarnedOnInvestment,
            ),
            TitleHeader(text: "Pension Wealth Generated"),
            GlobalOutputField(
              outputValue: pensionWealthGenerated,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------NPS CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------TAX CALCULATOR------------------------------------------------------------------------------------------------------------

class TaxCalculator extends StatefulWidget {
  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> {
  TextEditingController currentAge = new TextEditingController();
  TextEditingController elss = new TextEditingController();
  TextEditingController lic = new TextEditingController();
  TextEditingController ssy = new TextEditingController();
  TextEditingController fd = new TextEditingController();
  TextEditingController ppf = new TextEditingController();
  TextEditingController insurance = new TextEditingController();
  TextEditingController otherAmt = new TextEditingController();
  TextEditingController salary = new TextEditingController();

  var _options = ['0-59', '60-79', '>=80'];
  var _currentItemSelected = '0-59';

  String yourCurrentInvestments = "0";
  String furtherInvestmentOpportunity = "0";
  String taxSaved = "0";

  var age;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Tax Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryColor,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(
              text: "**Investment limit under Sec 80C Rs.1,50,000",
            ),
            SizedBox(
              height: 3,
            ),
            TitleHeader(
              text: "How much are you investing annually in the following",
            ),
            TitleHeader(text: "Equity linked saving scheme(ELSS)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
              dataController: elss,
            ),
            TitleHeader(text: "Life insurance premium paid"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: lic,
            ),
            TitleHeader(text: "Sukanya Samriddhi Yojna"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: ssy,
            ),
            TitleHeader(text: "5 years fixed deposit"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: fd,
            ),
            TitleHeader(text: "PPF investment"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: ppf,
            ),
            TitleHeader(text: "Unit linked insurance plan"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: insurance,
            ),
            TitleHeader(text: "Any other 80C"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: otherAmt,
            ),
            TitleHeader(text: "Your annual salary"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
              dataController: salary,
            ),
            TitleHeader(text: "Age"),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
              child: Container(
                height: getProportionateScreenHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    elevation: 0,
                    items: _options.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      _dropDownItemSelected(newValueSelected);
                    },
                    value: _currentItemSelected,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        if (_currentItemSelected == '0-59') {
                          age = 'normal';
                        } else if (_currentItemSelected == '60-79') {
                          age = 'old';
                        } else if (_currentItemSelected == '>=80') {
                          age = 'seniorCitizen';
                        }
                        var elss1 = double.tryParse(elss.text);
                        var lic1 = double.tryParse(lic.text);
                        var ssy1 = double.tryParse(ssy.text);
                        var fd1 = double.tryParse(fd.text);
                        var ppf1 = double.tryParse(ppf.text);
                        var insurance1 = double.tryParse(insurance.text);
                        var otherAmt1 = double.tryParse(otherAmt.text);
                        var salary1 = double.tryParse(salary.text);
                        var totalInvest = (elss1 +
                            lic1 +
                            ssy1 +
                            fd1 +
                            ppf1 +
                            insurance1 +
                            otherAmt1);
                        var remainingSalary = salary1 - totalInvest;
                        var tax = 0.0;
                        var furInvest;
                        var taxSavedFromFurInv;
                        if (totalInvest > 150000) {
                          furInvest = 0;
                        } else {
                          furInvest = 150000 - totalInvest;
                        }
                        if (age == "normal") {
                          if (remainingSalary > 250000 &&
                              remainingSalary <= 500000) {
                            tax = ((remainingSalary - 250000) * 5 / 100);
                          }
                          if (remainingSalary > 500000 &&
                              remainingSalary <= 1000000) {
                            tax =
                                12500 + ((remainingSalary - 500000) * 20 / 100);
                          }
                          if (remainingSalary > 1000000) {
                            tax = (12500 + 100000) +
                                ((remainingSalary - 500000) * 30 / 100);
                          }

                          if (salary1 <= 250000) {
                            taxSavedFromFurInv = (furInvest * 0 / 100);
                          }
                          if (salary1 > 250000 && salary1 <= 500000) {
                            taxSavedFromFurInv = (furInvest * 5 / 100);
                          }
                          if (salary1 > 500000 && salary1 <= 1000000) {
                            taxSavedFromFurInv = (furInvest * 20 / 100);
                          }
                          if (salary1 > 1000000) {
                            taxSavedFromFurInv = (furInvest * 30 / 100);
                          }
                        } else if (age == "old") {
                          if (remainingSalary > 300000 &&
                              remainingSalary <= 500000) {
                            tax = ((remainingSalary - 300000) * 5 / 100);
                          }
                          if (remainingSalary > 500000 &&
                              remainingSalary <= 1000000) {
                            tax =
                                10000 + ((remainingSalary - 500000) * 20 / 100);
                          }
                          if (remainingSalary > 1000000) {
                            tax = (10000 + 100000) +
                                ((remainingSalary - 500000) * 30 / 100);
                          }

                          if (salary1 <= 300000) {
                            taxSavedFromFurInv = (furInvest * 0 / 100);
                          }
                          if (salary1 > 300000 && salary1 <= 500000) {
                            taxSavedFromFurInv = (furInvest * 5 / 100);
                          }
                          if (salary1 > 500000 && salary1 <= 1000000) {
                            taxSavedFromFurInv = (furInvest * 20 / 100);
                          }
                          if (salary1 > 1000000) {
                            taxSavedFromFurInv = (furInvest * 30 / 100);
                          }
                        } else if (age == "seniorCitizen") {
                          if (remainingSalary > 500000 &&
                              remainingSalary <= 1000000) {
                            tax = (remainingSalary - 500000) * 20 / 100;
                          }
                          if (remainingSalary > 1000000) {
                            tax = (100000) +
                                ((remainingSalary - 500000) * 30 / 100);
                          }

                          if (salary1 <= 500000) {
                            taxSavedFromFurInv = (furInvest * 0 / 100);
                          }
                          if (salary1 > 500000 && salary1 <= 1000000) {
                            taxSavedFromFurInv = (furInvest * 20 / 100);
                          }
                          if (salary1 > 1000000) {
                            taxSavedFromFurInv = (furInvest * 30 / 100);
                          }
                        }
                        yourCurrentInvestments =
                            (totalInvest.round()).toString();
                        furtherInvestmentOpportunity =
                            (furInvest.round()).toString();
                        taxSaved = (taxSavedFromFurInv.round()).toString();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Your current investments"),
            GlobalOutputField(
              outputValue: yourCurrentInvestments,
            ),
            TitleHeader(text: "Further investment opportunity"),
            GlobalOutputField(
              outputValue: furtherInvestmentOpportunity,
            ),
            TitleHeader(text: "Tax saved through further investment"),
            GlobalOutputField(
              outputValue: taxSaved,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

//-------------------------------------------------------------------------------------TAX CALCULATOR------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------OLD VS NEW CALCULATOR------------------------------------------------------------------------------------------------------------

class OldVsNewTax extends StatefulWidget {
  @override
  _OldVsNewTaxState createState() => _OldVsNewTaxState();
}

class _OldVsNewTaxState extends State<OldVsNewTax> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Old vs New Tax Regime Compare",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryColor,
                    ),
                  ),
                  Spacer(),
                  CloseButton(),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(
              text: "Salary Income",
              richText: " (Including all allowance/perks)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(
              text: "Investment in 80D",
              richText: " (Medical Insurance, Expenditure up to 75K)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Rental Income"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Leave Travel Allowance Claim"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(text: "80G Donation", richText: " (100%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(text: "80G Donation", richText: " (50%)"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Interest On House Loan"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(
              text: "Investment in 80C",
              richText: " (insurance/FD/PPF/MF/EPF/Equity)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Fixed Deposit Interest"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(
              text: "Food Coupon",
              richText: " (Tax Exempted)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "National Pension Scheme"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: getProportionateScreenWidth(18),
                ),
                Text(
                  "Other Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kPrimaryColor,
                  ),
                ),
                Spacer(),
              ],
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeaderWithRichText(
              text: "Rent Paid",
              richText: " (Per Month)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Age"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(
              text: "HRA Component in salary",
              richText: " (Per Month)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            TitleHeaderWithRichText(
              text: "Basic Salary",
              richText: " (Per Month)",
            ),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Amount Here",
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: getProportionateScreenWidth(18),
                ),
                Text(
                  "Personal Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kPrimaryColor,
                  ),
                ),
                Spacer(),
              ],
            ),
            Divider(
              thickness: 0.2,
              color: kPrimaryColor,
            ),
            TitleHeader(text: "Name*"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.name,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Email*"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.emailAddress,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Phone Number*"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.phone,
              hintText: "Amount Here",
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0, top: 30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(150),
                  child: FlatButton(
                    child: Text('Compute',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------OLD VS NEW CALCULATOR------------------------------------------------------------------------------------------------------------
