import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optymoney/PostLogin/Tax/tax.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/PostLogin/investments/investments.dart';
import 'package:optymoney/PostLogin/resources/resources.dart';
import 'package:optymoney/PostLogin/settings/settings.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/size_config.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int currentIndex = 2;

  List pageList = [
    Tax(),
    Investments(),
    DashBoardData(),
    Resources(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        //containerHeight: getProportionateScreenHeight(10),
        selectedIndex: currentIndex,
        curve: Curves.bounceInOut,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: FaIcon(FontAwesomeIcons.file),
            title: Text("Tax"),
            activeColor: kPrimaryColor,
            inactiveColor: kPrimaryColor,
          ),
          BottomNavyBarItem(
            icon: FaIcon(FontAwesomeIcons.moneyCheck),
            title: Text("Investments"),
            activeColor: kPrimaryColor,
            inactiveColor: kPrimaryColor,
          ),
          BottomNavyBarItem(
            icon: FaIcon(FontAwesomeIcons.dashcube),
            title: Text("Dashboard"),
            activeColor: kPrimaryColor,
            inactiveColor: kPrimaryColor,
          ),
          BottomNavyBarItem(
            icon: FaIcon(FontAwesomeIcons.blog),
            title: Text("Resources"),
            activeColor: kPrimaryColor,
            inactiveColor: kPrimaryColor,
          ),
          BottomNavyBarItem(
            icon: FaIcon(FontAwesomeIcons.cogs),
            title: Text("Settings"),
            activeColor: kPrimaryColor,
            inactiveColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
