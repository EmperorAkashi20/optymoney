import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class TestPage extends StatefulWidget {
  static String routeName = "/test";
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<ChartsData> chartData = [];

  @override
  void initState() {
    loadSalesData();
    super.initState();
  }

  Future<String> getDataFromJson() async {
    var url = Uri.parse('https://optymoney.com/__lib.ajax/ajax_response.php');
    final headers = {'content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'get_nav': 'yes',
      'sch_code': 'SU5GMjA0S0IxNVoz',
    };

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print(response.body);
    return response.body;
  }

  Future loadSalesData() async {
    final String jsonString = await getDataFromJson();
    print(jsonString);
    final dynamic jsonResponse = json.decode(jsonString);
    print(jsonResponse);
    print('object');
    for (Map<String, dynamic> i in jsonResponse)
      chartData.add(ChartsData.fromJson(i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: getDataFromJson(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: 300,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      series: <ChartSeries<ChartsData, String>>[
                        LineSeries(
                          dataSource: chartData,
                          xValueMapper: (ChartsData charts, _) =>
                              charts.price.toString(),
                          yValueMapper: (ChartsData charts, _) =>
                              charts.date.toNum(),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  child: Text('Loading'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ChartsData {
  ChartsData(this.date, this.price);

  var date;
  var price;

  factory ChartsData.fromJson(Map<String, dynamic> parsedJson) {
    return ChartsData(
      parsedJson['net_asset_value'],
      parsedJson['price_date'],
    );
  }
}
