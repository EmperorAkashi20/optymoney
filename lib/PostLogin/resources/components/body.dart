import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

var response;

class _BodyState extends State<Body> {
  void getData() async {
    var url =
        Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    //testData();
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawerMain(),
      body: Container(
        child: Center(child: Text("The Content will be live soon")),
      ),
    );
  }
}
