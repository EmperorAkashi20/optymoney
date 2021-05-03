import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    //testData();
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawerMain(),
    );
  }
}
