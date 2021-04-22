import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      drawer: AppDrawerMain(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        SignForm.name,
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        SignForm.email1,
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      SignForm.letter,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
