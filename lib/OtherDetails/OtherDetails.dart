import 'package:flutter/material.dart';
import 'package:optymoney/OtherDetails/Components/body.dart';

class OtherDetailsScreen extends StatelessWidget {
  static String routeName = "/OtherDetails";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
