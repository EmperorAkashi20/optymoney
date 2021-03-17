import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var longitude;
  late var response;

  void getData() async {
    // http.Response response = await http.get(
    //     "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=39&appid=");
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);

      longitude = jsonDecode(data)['coord']['lon'];
      print(longitude);

      var description = jsonDecode(data)['weather'][0]['description'];
      print(description);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    //testData();
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawerMain(),
    );
  }
}
