import 'package:flutter/material.dart';
import 'package:optymoney/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:optymoney/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          AnimatedTextKit(
            animatedTexts: [
              RotateAnimatedText(
                  'Just a few more details\nbefore we get you started',
                  textStyle: TextStyle(
                      color: kTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w900)),
              RotateAnimatedText(
                  'We require this to\nto optimize your experience',
                  textStyle: TextStyle(
                      color: kTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w900)),
            ],
            //speed: const Duration(milliseconds: 2000),
            totalRepeatCount: 30,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: false,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: ClipOval(
                child: Material(
                  color: kPrimaryColor, // button color
                  child: InkWell(
                    splashColor: Colors.blue, // inkwell color
                    child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.arrow_forward)),
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
