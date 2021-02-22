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
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/car.png",
                  title: "Buy A Car",
                  navigationRoute: () {},
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
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/house.png",
                  title: "Own A House",
                  navigationRoute: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LifeGoalsButtonTile(
                  image: "assets/images/wedding.png",
                  title: "Grand Wedding",
                  navigationRoute: () {},
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/vacation.png",
                  title: "Plan A Vacation",
                  navigationRoute: () {},
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
                ),
                LifeGoalsButtonTile(
                  image: "assets/images/uniquegoal.png",
                  title: "Unique Goal",
                  navigationRoute: () {},
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
    Key key,
    @required this.image,
    @required this.title,
    @required this.navigationRoute,
  }) : super(key: key);

  final String image;
  final String title;
  final Function navigationRoute;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FlatButton(
          onPressed: navigationRoute,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: kPrimaryColor),
          ),
          child: Container(
            height: getProportionateScreenHeight(130),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  height: getProportionateScreenHeight(80),
                  width: getProportionateScreenWidth(80),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
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
