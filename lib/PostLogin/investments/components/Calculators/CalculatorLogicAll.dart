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
  var fvInvestment = 0.0;

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
                        sipAmount = double.tryParse(sip1Amount.text);
                        noOfYrs = double.tryParse(investedFor.text);
                        r = double.tryParse(expectedRateOfReturn.text);
                        i = double.parse(inflationRate.text);
                        returnRate = r / 100;
                        inflationRateController = i / 100;
                        investedAmount = sipAmount * (noOfYrs * 12);
                        a = (1 + returnRate);
                        b = (1 + inflationRateController);
                        realReturn = ((a / b) - 1);
                        c = pow((1 + realReturn), (1 / (noOfYrs * 12)));
                        nominalRate = noOfYrs * (c - 1);
                        d = pow((1 + nominalRate), (noOfYrs * 12));
                        nominalRate1 = (1 + nominalRate);
                        fv1 = sipAmount * (nominalRate1) / nominalRate;
                        fvInvestment = (d * fv1) - fv1;
                        double sum = sipAmount * noOfYrs * r * i;
                        amountInvested = sum.toString();
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
              outputValue: "amountInvested",
            ),
            TitleHeader(text: "Future Value Investment Of"),
            GlobalOutputField(
              outputValue: amountInvested,
            ),
            SuggestionBox1(
              suggestion: "If you invest ₹" +
                  sipAmount.toString() +
                  " per month for " +
                  noOfYrs.toString() +
                  " years @ " +
                  r.toString() +
                  " % P.A expected rate of return, you will accumulate ₹ ***** at the end of the " +
                  noOfYrs.toString() +
                  " years.",
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
            )
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
            )
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
            )
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
            TitleHeader(text: "Amount Invested"),
            GlobalOutputField(
              outputValue: amountInvested,
            ),
            TitleHeader(text: "Future Value Of Investment"),
            GlobalOutputField(
              outputValue: futureValueOfInvestment,
            ),
            SuggestionBox1(
              suggestion:
                  "If you invest ₹ ***** per month for *** years @ **% P.A expected rate of return, you will accumulate ₹ ***** at the end of the **th year.",
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
  var _currentItemSelected = 'Delhi';

  TextEditingController basicSalaryReceived = new TextEditingController();
  TextEditingController dearnessAllowanceReceived = new TextEditingController();
  TextEditingController hraReceived = new TextEditingController();
  TextEditingController actualRentPaid = new TextEditingController();

  String hraExemption = "0";
  String hraTaxable = "0";

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
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate Here",
              dataController: ppfInterestRate,
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
  var _currentItemSelected = 'Low - 7%';

  TextEditingController amountYouWantToAchieve = new TextEditingController();
  TextEditingController withinNumberOfYears = new TextEditingController();
  TextEditingController rateOfReturn = new TextEditingController();

  String monthlySipInvestmentNeeded = "0";

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
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.number,
              hintText: "Rate % Here",
              dataController: rateOfReturn,
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
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Divider(),
            OutputTextForPopUp(),
            TitleHeader(text: "Monthly Investment Required"),
            GlobalOutputField(
              outputValue: monthlySipInvestmentNeeded,
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
                hintText: "Rate % Here"),
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
                    child: Expanded(
                      child: Text('Compute',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    ),
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
            )
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
                hintText: "Year Here"),
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
                        int sum = int.parse(amountInvestedMonthly.text) *
                            int.parse(investedForNoOfYears.text);
                        maturityValue = sum.toString();
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
                suggestion: " Earn More then RD's by Investing MF's ")
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
  var _options = ['0-59', '60-79', '>=80'];
  var _currentItemSelected = '0-59';

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
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Life insurance premium paid"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Sukanya Samriddhi Yojna"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "5 years fixed deposit"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "PPF investment"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Unit linked insurance plan"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Any other 80C"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
            ),
            TitleHeader(text: "Your annual salary"),
            FormFieldGlobal(
              keyboardTypeGlobal: TextInputType.text,
              hintText: "Amount Here",
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
            TitleHeader(text: "Your current investments"),
            GlobalOutputField(
              outputValue: "",
            ),
            TitleHeader(text: "Further investment opportunity"),
            GlobalOutputField(
              outputValue: "",
            ),
            TitleHeader(text: "Tax saved through further investment"),
            GlobalOutputField(
              outputValue: "",
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
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------OLD VS NEW CALCULATOR------------------------------------------------------------------------------------------------------------
