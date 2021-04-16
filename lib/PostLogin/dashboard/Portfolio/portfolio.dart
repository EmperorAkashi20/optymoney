import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/Portfolio/Components/body.dart';

import '../../../size_config.dart';

class Portfolio extends StatelessWidget {
  static String routeName = "/portfolio";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: 500,
      child: Body(),
    );
  }
}
