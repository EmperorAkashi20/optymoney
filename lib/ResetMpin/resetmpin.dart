import 'package:flutter/material.dart';
import 'package:optymoney/ResetMpin/Components/body.dart';

class ResetMpinScreen extends StatelessWidget {
  static String routeName = "/resetmpin";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
