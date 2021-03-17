import 'package:flutter/material.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/size_config.dart';

class LifeGoalsButtons extends StatefulWidget {
  @override
  _LifeGoalsButtonsState createState() => _LifeGoalsButtonsState();
}

class _LifeGoalsButtonsState extends State<LifeGoalsButtons> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LifeGoalsButtonTile(
                  image: "assets/images/retire.png",
                  title: "Retire Rich",
                  navigationRoute: () {},
                  imageHeight: 45,
                  imageWidth: 45,
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/car.png",
                  title: "Buy A Car",
                  navigationRoute: () {},
                  imageHeight: 45,
                  imageWidth: 45,
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/house.png",
                  title: "Your House",
                  navigationRoute: () {},
                  imageHeight: 45,
                  imageWidth: 45,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LifeGoalsButtonTile(
                  image: "assets/images/education.png",
                  title: "Higher Education",
                  navigationRoute: () {},
                  imageHeight: 45,
                  imageWidth: 45,
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/wedding.png",
                  title: "Grand Wedding",
                  navigationRoute: () {},
                  imageHeight: 45,
                  imageWidth: 45,
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/vacation.png",
                  title: "Plan A Vacation",
                  navigationRoute: () {},
                  imageHeight: 45,
                  imageWidth: 45,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LifeGoalsButtonTile(
                  image: "assets/images/emergencyfund.png",
                  title: "Emergency Fund",
                  navigationRoute: () {},
                  imageHeight: 30,
                  imageWidth: 30,
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/uniquegoal.png",
                  title: "Unique Goal",
                  navigationRoute: () {},
                  imageHeight: 30,
                  imageWidth: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LifeGoalsButtonTile extends StatelessWidget {
  const LifeGoalsButtonTile({
    Key? key,
    required this.image,
    required this.title,
    required this.navigationRoute,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  final String image;
  final String title;
  final Function navigationRoute;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FlatButton(
          onPressed: navigationRoute as void Function()?,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: kPrimaryColor),
          ),
          child: Container(
            height: getProportionateScreenHeight(130),
            width: getProportionateScreenWidth(130),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  height: getProportionateScreenHeight(imageHeight),
                  width: getProportionateScreenWidth(imageWidth),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
