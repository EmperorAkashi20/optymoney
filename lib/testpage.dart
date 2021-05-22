import 'package:flutter/material.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/models.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:optymoney/SchemeDisplay/Componenets/body.dart';

class TestPage extends StatefulWidget {
  static String routeName = "/test";
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  double height = Body.minAmt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfSlider(
                enableTooltip: true,
                activeColor: kPrimaryColor,
                min: Body.minAmt,
                max: Body.maxAmt,
                value: height.toDouble(),
                onChanged: (dynamic value) {
                  setState(() {
                    height = value;
                  });
                },
              ),
              GlobalOutputField(
                outputValue: height.toStringAsFixed(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
