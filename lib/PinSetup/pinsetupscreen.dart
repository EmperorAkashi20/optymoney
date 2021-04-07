import 'package:flutter/material.dart';
import 'package:optymoney/PinSetup/Components/body.dart';

import '../size_config.dart';

class PinSetupScreen extends StatelessWidget {
  static String routeName = "/pin";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
