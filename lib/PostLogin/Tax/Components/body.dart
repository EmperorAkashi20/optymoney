import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:optymoney/Components/outlinebtn.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

Future<http.StreamedResponse> makeItrRequest() async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
        'https://optymoney.com/ajax-request/ajax_response.php?action=itrRegistration&subaction=submit'),
  );
  request.headers.addAll({
    "content-type": "multipart/form-data",
  });
  request.fields['itr_e'] = 'itr';
  request.fields['fname'] = 'Sai Krishna Porala';
  request.fields['mobile'] = '9606796516';
  request.fields['pan'] = 'AXFPP0304C';
  request.fields['dobofusr'] = '1998-02-12';
  request.fields['address'] =
      'No 38/b 3rd cross prakruthi nagar kogilu main road yelahanka bangalore KA';
  request.fields['father_name'] = 'P Krishna Murthy';
  request.fields['email'] = 'saikrishnaporala@gmail.com';
  request.fields['aadhaar'] = '543554326543';
  request.fields['description'] = '';
  request.fields['bank'] = Body.bank;
  request.fields['acno'] = '004001568263';
  request.fields['ifsc'] = 'icic0000040';
  request.fields['c_acnt_c'] = '0';
  request.fields['c_acnt'] = '';
  request.fields['f_travel_c'] = '0';
  request.fields['f_travel_val'] = '';
  request.fields['e_bill_c'] = '0';
  request.fields['e_bill'] = '';
  request.fields['uid'] = SignForm.userIdGlobal;
  if (Body.filesitr != null) {
    request.files.add(
      http.MultipartFile(
          'fileitr',
          File(Body.filesitr[0]).readAsBytes().asStream(),
          File(Body.filesitr[0]).lengthSync(),
          filename: Body.filesitr[0].split("/").last),
    );
  }
  if (Body.addfileitr != null) {
    request.files.add(
      http.MultipartFile(
          'addfileitr',
          File(Body.addfileitr[0]).readAsBytes().asStream(),
          File(Body.addfileitr[0]).lengthSync(),
          filename: Body.addfileitr[0].split("/").last),
    );
  }
  if (Body.noticecopy != null) {
    request.files.add(
      http.MultipartFile(
          'noticecopy',
          File(Body.noticecopy[0]).readAsBytes().asStream(),
          File(Body.noticecopy[0]).lengthSync(),
          filename: Body.noticecopy[0].split("/").last),
    );
  }
  if (Body.itrfiledcopy != null) {
    request.files.add(
      http.MultipartFile(
          'itrfiledcopy',
          File(Body.itrfiledcopy[0]).readAsBytes().asStream(),
          File(Body.itrfiledcopy[0]).lengthSync(),
          filename: Body.itrfiledcopy[0].split("/").last),
    );
  }
  if (Body.addeassest != null) {
    request.files.add(
      http.MultipartFile(
          'addeassest',
          File(Body.addeassest[0]).readAsBytes().asStream(),
          File(Body.addeassest[0]).lengthSync(),
          filename: Body.addeassest[0].split("/").last),
    );
  }
  var res = await request.send();
  var response = await res.stream.bytesToString();
  print(response);
  return res;
}

class Body extends StatefulWidget {
  static var filesitr;
  static var addfileitr;
  static var noticecopy;
  static var itrfiledcopy;
  static var addeassest;

  static var bank;
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _itr = false;
  bool _ebill = false;
  bool _deposit = false;
  bool _foreignTravel = false;
  TextEditingController bankName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Center(
              child: Text(
                "Financial Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TitleHeader(text: 'Bank Name'),
            FormFieldGlobal(
              hintText: "Enter Your Bank Name",
              dataController: bankName,
            ),
            TitleHeader(text: 'Account Number'),
            FormFieldGlobal(
              hintText: "Enter your Account Number",
              keyboardTypeGlobal: TextInputType.number,
            ),
            TitleHeader(text: 'IFSC'),
            FormFieldGlobal(
              hintText: "Enter Your IFSC Code",
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ITR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 50.0),
                    child: Switch.adaptive(
                      value: _itr,
                      onChanged: (bool value) {
                        setState(() {
                          _itr = value;
                          print(value);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "E-Assessment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_itr == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                // print('\nfile:' + result.paths.toString());
                                Body.filesitr = result.paths;
                              }
                            },
                            child: Text(
                              "Form 16/16A",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                // print('\nfile:' + result.paths.toString());
                                Body.addfileitr = result.paths;
                              }
                            },
                            child: Text(
                              "Other Attachment",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_itr == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                // print('\nfile:' + result.paths.toString());
                                Body.noticecopy = result.paths;
                              }
                            },
                            child: Text(
                              "Notice Copy",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                // print('\nfile:' + result.paths.toString());
                                Body.itrfiledcopy = result.paths;
                              }
                            },
                            child: Text(
                              "Last ITR Filed",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                // print('\nfile:' + result.paths.toString());
                                Body.addeassest = result.paths;
                              }
                            },
                            child: Text(
                              "Other Attachment",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SwitchListTile.adaptive(
              title: Text("Does your total deposists exceed 1Cr?"),
              value: _deposit,
              onChanged: (bool value) {
                setState(() {
                  _deposit = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              title:
                  Text("Does your total electricity charges exceed Rs. 1Lakh?"),
              value: _ebill,
              onChanged: (bool value) {
                setState(() {
                  _ebill = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              title: Text(
                  "Foreign Travel expenses for self or other person in family exceeds Rs. 2Lakhs?"),
              value: _foreignTravel,
              onChanged: (bool value) {
                setState(() {
                  _foreignTravel = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () async {
                  Body.bank = bankName.text.toString();
                  await makeItrRequest();
                },
                child: OutlineBtn(btnText: "Proceed"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
