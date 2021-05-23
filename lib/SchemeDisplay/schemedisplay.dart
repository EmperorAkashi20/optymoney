import 'package:flutter/material.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AllSchemeDisplay.dart';
import 'package:optymoney/SchemeDisplay/Componenets/body.dart';
import 'package:optymoney/constants.dart';

class SchemeDisplay extends StatelessWidget {
  static String routeName = "/schemeDisplay";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: kPrimaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Text(
                  'Best Offerings',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'All Mutual Funds',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Body(),
            AllSchemeDisplay(),
          ],
        ),
      ),
    );
  }
}
