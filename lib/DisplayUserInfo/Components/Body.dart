import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool enableNow = false;
  Color disabledColor = Colors.grey;
  Color stringColorSave = Colors.grey.shade600;
  Color stringColorEdit = kPrimaryColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Profile"),
      ),
      drawer: AppDrawerMain(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          SignForm.name,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          SignForm.email1,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: Text(
                        SignForm.letter,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TitleHeader(text: "D.O.B"),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userBday,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Address"),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userAddress1,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userAddress2,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userAddress3,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userCity,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userState,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userPinCode,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userCountry,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              TitleHeader(text: "Mobile Number"),
              FormFieldDisplayProfile(
                enabledOrNot: enableNow,
                hintText: SignForm.userMobile,
                keyboardTypeGlobal: TextInputType.text,
                stringColor: disabledColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: stringColorEdit,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        enableNow = true;
                        disabledColor = Colors.black87;
                        stringColorSave = kPrimaryColor;
                        stringColorEdit = Colors.grey;
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: stringColorSave,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        enableNow = false;
                        disabledColor = Colors.grey;
                        stringColorSave = Colors.grey.shade600;
                        stringColorEdit = kPrimaryColor;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
