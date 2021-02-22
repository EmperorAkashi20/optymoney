import 'package:flutter/material.dart';

import '../size_config.dart';

class ReadMoreButton extends StatelessWidget {
  const ReadMoreButton({
    Key key,
    this.press,
  }) : super(key: key);
  final Function press;

  @override                                       //Pop Up Dialog Box
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(140),
      height: getProportionateScreenHeight(30),
      child: OutlineButton(
          child: Text("Read More >>",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white70,
          onPressed: () {

          }
      ),
    );
  }
}
