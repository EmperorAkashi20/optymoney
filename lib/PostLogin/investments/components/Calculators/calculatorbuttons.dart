import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/investments/components/Calculators/CalculatorLogicAll.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CalculatorButtons extends StatefulWidget {
  @override
  _CalculatorButtonsState createState() => _CalculatorButtonsState();
}

class _CalculatorButtonsState extends State<CalculatorButtons> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalculatorTile(
                  letter: "S",
                  name: "SIP Calculator",
                  navigationRoute: SipCalcFrom(),
                ),
                CalculatorTile(
                  letter: "E",
                  name: "EMI Home Loan",
                  navigationRoute: EmiHomeLoanCalcForm(),
                ),
                CalculatorTile(
                  letter: "S",
                  name: "Sukanya Samriddhi",
                  navigationRoute: SukanyaSamriddhiCalcForm(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalculatorTile(
                  letter: "L",
                  name: "Lump Sum",
                  navigationRoute: LumpSumCalcFrom(),
                ),
                CalculatorTile(
                  letter: "E",
                  name: "EMI Car Loan",
                  navigationRoute: EmiCarLoanCalcForm(),
                ),
                CalculatorTile(
                  letter: "H",
                  name: "House Rent",
                  navigationRoute: HraCalcFrom(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalculatorTile(
                  letter: "T",
                  name: "Tax Calculator",
                  navigationRoute: TaxCalculator(),
                ),
                CalculatorTile(
                  letter: "E",
                  name: "EMI Personal Loan",
                  navigationRoute: EmiPersonalLoanCalcForm(),
                ),
                CalculatorTile(
                  letter: "S",
                  name: "SIP Installment",
                  navigationRoute: SipInstallmentCalcForm(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalculatorTile(
                  letter: "F",
                  name: "Fixed Deposit Calculator",
                  navigationRoute: FixedDepositCalcForm(),
                ),
                CalculatorTile(
                  letter: "P",
                  name: "PPF Calculator",
                  navigationRoute: PpfCalcFrom(),
                ),
                CalculatorTile(
                  letter: "T",
                  name: "Tax Regime Compare",
                  navigationRoute: OldVsNewTax(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CalculatorTile(
                  letter: "R",
                  name: "Recurring Deposit",
                  navigationRoute: RecurringDepositCalcForm(),
                ),
                CalculatorTile(
                  letter: "N",
                  name: "NPS Calculator",
                  navigationRoute: NpsCalcForm(),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorTile extends StatelessWidget {
  const CalculatorTile({
    @required this.letter,
    @required this.name,
    this.navigationRoute,
    Key key,
  }) : super(key: key);

  final String letter;
  final String name;
  final Widget navigationRoute;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FlatButton(
          onPressed: () {
            showCupertinoModalBottomSheet(
              expand: false,
              isDismissible: true,
              enableDrag: true,
              bounce: true,
              duration: Duration(milliseconds: 400),
              context: context,
              builder: (context) => Scaffold(
                body: navigationRoute,
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: kPrimaryColor),
          ),
          child: Container(
            height: getProportionateScreenHeight(100),
            width: getProportionateScreenWidth(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  letter,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
