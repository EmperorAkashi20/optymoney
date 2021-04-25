import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optymoney/DisplayUserInfo/DisplayUserInfo.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/Components/body.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/portfolio.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/UserInfo/Components/ProfileComplete.dart';
import 'package:optymoney/UserInfo/Components/UserInfo.dart';
import 'package:optymoney/UserInfo/UserInfoStartScreen.dart';
import 'package:optymoney/sign_in_screen/sign_in_screen.dart';
import 'package:optymoney/size_config.dart';

import '../../constants.dart';

class DashBoardData extends StatefulWidget {
  @override
  _DashBoardDataState createState() => new _DashBoardDataState();
}

class _DashBoardDataState extends State<DashBoardData>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Overview Of Your Investments"),
      ),
      drawer: AppDrawerMain(),
      body: new ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TabBarConstants(
                    icon:
                        FaIcon(FontAwesomeIcons.arrowAltCircleUp), //size: 15),
                    title: "Profit/Loss",
                    initialAmount: "₹0.0",
                  ),
                  TabBarConstants(
                    icon: FaIcon(FontAwesomeIcons.piggyBank), //size: 15),
                    title: "Invested Value",
                    initialAmount: ("₹" + Body.purchasePrice.toString()),
                  ),
                  TabBarConstants(
                    icon: FaIcon(FontAwesomeIcons.filePowerpoint), //size: 15),
                    title: "Present Value",
                    initialAmount: "₹0.0",
                  )
                ],
              ),
            ),
          ),
          new Container(
            child: new TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: kPrimaryColor,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: kPrimaryColor,
              ),
              controller: _controller,
              tabs: [
                Tab(
                  child: TabBarMenuItem(title: "Wealth"),
                ),
                Tab(
                  child: TabBarMenuItem(title: "Will"),
                ),
                Tab(
                  child: TabBarMenuItem(
                    title: "Income Tax",
                  ),
                ),
              ],
            ),
          ),
          new Container(
            height: getProportionateScreenHeight(540),
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                Portfolio(),
                Center(child: Text("The Content will be live soon...")),
                Center(child: Text("The Content will be live soon...")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawerMain extends StatelessWidget {
  const AppDrawerMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 25,
                  child: Center(
                    child: Text(
                      Body.custLetter,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Text(
                  Body.custName,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  Body.emailId,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
          AppDrawerListTIle(
            title: "Dashboard",
            icon: FaIcon(
              FontAwesomeIcons.stopwatch,
            ),
            navigationRoute: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PostLoginStartsHere.routeName);
            },
          ),
          AppDrawerListTIle(
            title: "Profile",
            icon: FaIcon(
              FontAwesomeIcons.stopwatch,
            ),
            navigationRoute: () {
              Navigator.pop(context);
              if (Body.custPan == 'null') {
                Navigator.pushNamed(context, UserInfoScreen.routeName);
              } else {
                Navigator.pushNamed(context, DisplayUserInfoScreen.routeName);
              }
            },
          ),

          // AppDrawerListTIle(
          //   title: "Item 3",
          //   icon: FaIcon(
          //     FontAwesomeIcons.stopwatch,
          //   ),
          //   navigationRoute: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // AppDrawerListTIle(
          //   title: "Item 4",
          //   icon: FaIcon(
          //     FontAwesomeIcons.stopwatch,
          //   ),
          //   navigationRoute: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // AppDrawerListTIle(
          //   title: "Item 5",
          //   icon: FaIcon(
          //     FontAwesomeIcons.stopwatch,
          //   ),
          //   navigationRoute: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}

class AppDrawerListTIle extends StatelessWidget {
  const AppDrawerListTIle({
    Key? key,
    required this.title,
    required this.icon,
    this.navigationRoute,
  }) : super(key: key);

  final String title;
  final Widget icon;
  final Function? navigationRoute;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      trailing: Icon(Icons.arrow_right),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: navigationRoute as void Function()?,
    );
  }
}

class TabBarConstants extends StatelessWidget {
  const TabBarConstants({
    Key? key,
    required this.title,
    required this.initialAmount,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String initialAmount;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: icon,
          ),
        ),
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              initialAmount,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TabBarMenuItem extends StatelessWidget {
  const TabBarMenuItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: kPrimaryColor,
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
