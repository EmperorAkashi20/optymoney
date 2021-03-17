import 'dart:io';
import 'package:flutter/material.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/models.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

enum Selector { Yes, No }

class _BodyState extends State<Body> {
  DateTime selectedDate = DateTime.now();
  Selector? _selector = Selector.No;
  File? file;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        helpText: "SELECT YOUR DATE OF BIRTH",
        confirmText: "CONFIRM",
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark(),
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Your ITR with Us"),
      ),
      drawer: AppDrawerMain(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Personal Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TitleHeader(text: "Name"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. Jon Doe",
                  ),
                  TitleHeader(text: "Father's Name"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. Jon Doe",
                  ),
                  TitleHeader(text: "Mobile No."),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.phone,
                    hintText: "e.g. 99999 99999",
                  ),
                  TitleHeader(text: "Email"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.emailAddress,
                    hintText: "e.g. Jon Doe",
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Official Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TitleHeader(text: "PAN"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. ALPS123456",
                  ),
                  TitleHeader(text: "Aadhar / Enrollment No"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.number,
                    hintText: "e.g. 1234 1234 1234",
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 15),
                        child: Container(
                          width: getProportionateScreenWidth(123),
                          child: RaisedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () => _selectDate(context),
                            child: Text(
                              'Date Of Birth',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GlobalOutputField(
                    outputValue: "$selectedDate",
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 15),
                        child: Container(
                          width: getProportionateScreenWidth(123),
                          child: RaisedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () async {},
                            child: Text(
                              'Choose File',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GlobalOutputField(
                    outputValue: "No File Uploaded",
                  ),
                  TitleHeader(text: "Address"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.streetAddress,
                    hintText: "e.g. 123A, Your Complete Street Address",
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Text(
                    "Financial Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TitleHeader(text: "Bank Name"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. ICICI Bank",
                  ),
                  TitleHeader(text: "Account Number"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.number,
                    hintText: "e.g. 1234 1234 1224 1234",
                  ),
                  TitleHeader(text: "IFSC Code"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. IFSC1920",
                  ),
                  TitleHeader(text: "Does your total deposits exceed 1Cr?"),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('No'),
                        leading: Radio(
                          value: Selector.No,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                          value: Selector.Yes,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  TitleHeader(text: "Electricity charges exceed Rs. 1 Lakh?"),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('No'),
                        leading: Radio(
                          value: Selector.No,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                          value: Selector.Yes,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  TitleHeader(
                      text:
                          "Foreign Travel expenses for self or other person in family exceeds Rs. 2 Lakhs?"),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('No'),
                        leading: Radio(
                          value: Selector.No,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                          value: Selector.Yes,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 15),
                  child: Container(
                    width: getProportionateScreenWidth(123),
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () async {},
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      color: kPrimaryColor,
                    ),
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
