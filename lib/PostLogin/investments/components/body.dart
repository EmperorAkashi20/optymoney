import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/PostLogin/investments/components/Calculators/calculatorbuttons.dart';
import 'package:optymoney/PostLogin/investments/components/LifeGoals/lifegoalscalc.dart';
import 'package:optymoney/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Invest Freely With Us"),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: kPrimaryColor,
            ),
            unselectedLabelColor: kPrimaryColor,
            tabs: [
              InvestmentTabs(title: "Mutual Funds"),
              InvestmentTabs(title: "Calculators"),
              InvestmentTabs(title: "Life Goals"),
            ],
          ),
        ),
        drawer: AppDrawerMain(),
        body: TabBarView(
          children: [
            Icon(Icons.dashboard_sharp),
            CalculatorButtons(),
            LifeGoalsButtons(),
          ],
        ),
      ),
    );
  }
}

class InvestmentTabs extends StatelessWidget {
  const InvestmentTabs({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
      ),
    );
  }
}
