import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/models.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:optymoney/size_config.dart';

import '../../constants.dart';

addBankAccount() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=insertbank_api&subaction=Submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'bank_name': Body.bankAccountName.toString(),
    'acc_no': Body.bankAccountNumber.toString(),
    'ifsc_code': Body.bankAccountIfsc.toString(),
    'id': '',
    'uid': SignForm.userIdGlobal,
  };
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  var responseBody = response.body;
  var jsonData = json.decode(responseBody);
  print(jsonData);
}

class Body extends StatefulWidget {
  static TextEditingController bankAccountNameController =
      new TextEditingController();
  static TextEditingController bankAccountNumberController =
      new TextEditingController();
  static TextEditingController bankAccountIfscController =
      new TextEditingController();
  static var bankAccountName;
  static var bankAccountNumber;
  static var bankAccountIfsc;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isEditingText = false;
  late TextEditingController _editingController;

  Future<List<BankDetail>> _getBankDetail() async {
    var url = Uri.parse(
        'https://optymoney.com/ajax-request/ajax_response.php?action=getBankDetails_api&subaction=submit');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'uid': SignForm.userIdGlobal,
    };
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    var bankBody = response.body;
    var jsonData = json.decode(bankBody);
    print(jsonData);
    var len = jsonData.length;
    print('Length');
    print(len);
    List<BankDetail> bankDetails = [];
    for (var sch in jsonData) {
      BankDetail bankDetail = BankDetail(
        sch['pk_bank_detail_id'],
        sch['fr_user_id'],
        sch['bank_name'],
        sch['acc_no'],
        sch['ifsc_code'],
        sch['swift_code'],
        sch['mandate_id'],
        sch['mandate_start_dt'],
        sch['mandate_end_dt'],
        sch['default_bank'],
        sch['bank_created_date'],
        sch['bank_modified_date'],
      );

      if (sch['pk_bank_details_id'] != null) {
      } else {
        bankDetails.add(bankDetail);
      }
    }
    return bankDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawerMain(),
      body: Container(
        child: FutureBuilder(
            future: _getBankDetail(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingDoubleFlipping.circle(
                          borderColor: kPrimaryColor,
                          borderSize: 2.0,
                          size: 40.0,
                          backgroundColor: kPrimaryColor,
                        ),
                        Text('Loading...'),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.data.length == 0) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: getProportionateScreenHeight(120),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: kPrimaryColor,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Expanded(
                              child: Text(
                                'Please Tap on the \'+\'Icon in the bottom to add your account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: getProportionateScreenHeight(100),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Text(
                                            snapshot.data[index].bank_name
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            radius: 20,
                                            child: IconButton(
                                              icon: Icon(Icons.add_chart),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      Scaffold(
                                                    appBar: AppBar(
                                                      automaticallyImplyLeading:
                                                          false,
                                                      actions: [
                                                        CloseButton(),
                                                      ],
                                                    ),
                                                    body: Container(
                                                      child: Column(
                                                        children: [],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Account Number',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].acc_no
                                                  .toString(),
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'IFSC Code',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].ifsc_code
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: FloatingActionButton(
                          backgroundColor: kPrimaryColor,
                          child: Icon(
                            Icons.add,
                            size: 40,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  automaticallyImplyLeading: false,
                                  title: Text('Add New Bank Account'),
                                  actions: [CloseButton()],
                                ),
                                body: Container(
                                  child: Column(
                                    children: [
                                      TitleHeader(text: 'Bank Name'),
                                      FormFieldGlobal(
                                        dataController:
                                            Body.bankAccountNameController,
                                      ),
                                      TitleHeader(text: 'Account Number'),
                                      FormFieldGlobal(
                                        dataController:
                                            Body.bankAccountNumberController,
                                      ),
                                      TitleHeader(text: 'Bank IFSC Code'),
                                      FormFieldGlobal(
                                        dataController:
                                            Body.bankAccountIfscController,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: kPrimaryColor,
                                                width: 1,
                                              ),
                                            ),
                                            height:
                                                getProportionateScreenHeight(
                                                    40),
                                            width:
                                                getProportionateScreenWidth(80),
                                            child: TextButton(
                                              onPressed: () async {
                                                Body.bankAccountIfsc = Body
                                                    .bankAccountIfscController
                                                    .text;
                                                Body.bankAccountName = Body
                                                    .bankAccountNameController
                                                    .text;
                                                Body.bankAccountNumber = Body
                                                    .bankAccountNumberController
                                                    .text;
                                                await addBankAccount();
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'ADD',
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

class BankDetail {
  // ignore: non_constant_identifier_names
  final String pk_bank_detail_id;
  // ignore: non_constant_identifier_names
  final String fr_user_id;
  // ignore: non_constant_identifier_names
  final String bank_name;
  // ignore: non_constant_identifier_names
  final String acc_no;
  // ignore: non_constant_identifier_names
  final String ifsc_code;
  // ignore: non_constant_identifier_names
  final String swift_code;
  // ignore: non_constant_identifier_names
  final String mandate_id;
  // ignore: non_constant_identifier_names
  final String mandate_start_dt;
  // ignore: non_constant_identifier_names
  final String mandate_end_dt;
  // ignore: non_constant_identifier_names
  final String default_bank;
  // ignore: non_constant_identifier_names
  final String bank_created_date;
  // ignore: non_constant_identifier_names
  final String bank_modified_date;

  BankDetail(
    this.pk_bank_detail_id,
    this.fr_user_id,
    this.bank_name,
    this.acc_no,
    this.ifsc_code,
    this.swift_code,
    this.mandate_id,
    this.mandate_start_dt,
    this.mandate_end_dt,
    this.default_bank,
    this.bank_created_date,
    this.bank_modified_date,
  );
}
