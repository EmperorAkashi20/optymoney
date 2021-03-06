import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/BankDetails/bankdetails.dart';
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

  //var responseBody = response.body;
  //var jsonData = json.decode(responseBody);
  // print(jsonData);
}

deleteBankAccount() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=deletebank_api&subaction=Submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'id': Body.bankId,
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

  //var responseBody = response.body;
  //var jsonData = json.decode(responseBody);
  // print(jsonData);
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
  static var initialText;
  static var bankId;
  static TextEditingController editingController = new TextEditingController();
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isEditingText = false;
  Timer? _timer;
  late double _progress;
  var color1;
  bool enableNotEnable = false;

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
    //print(jsonData);
    //var len = jsonData.length;
    //print('Length');
    //print(len);
    List<BankDetail> bankDetails = [];
    for (var sch in jsonData) {
      Body.initialText = sch['bank_name'];
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Column(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.university,
                            color: Colors.grey.shade400,
                            size: 60,
                          ),
                          Text(
                            'You have not added any accounts,\nPurchase will Not be possible without adding accounts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Please Tap on the \'+\' Icon in the bottom to add your account',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.bottomRight,
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
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
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
                                                  getProportionateScreenWidth(
                                                      80),
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
                                                  _progress = 0;
                                                  _timer?.cancel();
                                                  _timer = Timer.periodic(
                                                      const Duration(
                                                          milliseconds: 10),
                                                      (Timer timer) async {
                                                    await EasyLoading.showProgress(
                                                        _progress,
                                                        status:
                                                            '${(_progress * 100).toStringAsFixed(0)}%');
                                                    _progress += 0.03;
                                                    if (_progress >= 1) {
                                                      _timer?.cancel();
                                                      EasyLoading.dismiss();
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _getBankDetail();
                                                  });
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
                          if (index == 0) {
                            color1 = kPrimaryColor;
                          } else if (index == 1) {
                            color1 = Colors.blue;
                          } else if (2 % index == 0) {
                            color1 = kPrimaryColor;
                          } else if (2 % index != 0) {
                            color1 = Colors.blue;
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              shadowColor: color1,
                              color: color1,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: kPrimaryColor),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
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
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                  FontAwesomeIcons.university,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    SignForm.name
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data[index].bank_name
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ],
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
                                                      title: Text(
                                                          'Manage Your Account'),
                                                      actions: [
                                                        CloseButton(),
                                                      ],
                                                    ),
                                                    body: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              TitleHeader(
                                                                text:
                                                                    "Bank Name",
                                                              ),
                                                              FormFieldGlobal(
                                                                enabledOrNot:
                                                                    enableNotEnable,
                                                              ),
                                                              TitleHeader(
                                                                text:
                                                                    "Account Number",
                                                              ),
                                                              FormFieldGlobal(
                                                                enabledOrNot:
                                                                    enableNotEnable,
                                                              ),
                                                              TitleHeader(
                                                                text:
                                                                    "IFSC Code",
                                                              ),
                                                              FormFieldGlobal(
                                                                enabledOrNot:
                                                                    enableNotEnable,
                                                              ),
                                                              if (enableNotEnable ==
                                                                  true)
                                                                TextButton(
                                                                    child: Text(
                                                                        'Save'),
                                                                    onPressed:
                                                                        () {}),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  color: Colors
                                                                      .blue,
                                                                  child: Center(
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          enableNotEnable =
                                                                              true;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Edit Details',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  color: Colors
                                                                      .red,
                                                                  child: Center(
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Body.bankId = snapshot
                                                                            .data[index]
                                                                            .pk_bank_detail_id
                                                                            .toString();

                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: Text('Please Confirm'),
                                                                              content: Text('Are you sure you want to delete this account?'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () async {
                                                                                    await deleteBankAccount();
                                                                                    _progress = 0;
                                                                                    _timer?.cancel();
                                                                                    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) async {
                                                                                      await EasyLoading.showProgress(_progress, status: '${(_progress * 100).toStringAsFixed(0)}%');
                                                                                      _progress += 0.03;
                                                                                      if (_progress >= 1) {
                                                                                        _timer?.cancel();
                                                                                        EasyLoading.dismiss();
                                                                                      }
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                    setState(() {
                                                                                      _getBankDetail();
                                                                                    });
                                                                                  },
                                                                                  child: Text('Yes'),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                    setState(() {
                                                                                      _getBankDetail();
                                                                                    });
                                                                                  },
                                                                                  child: Text('Cancel'),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Delete Account',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
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
                                    ),
                                    Divider(
                                      color: Colors.white,
                                      thickness: 0.3,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              'Account Number',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].acc_no
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              'IFSC Code',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].ifsc_code
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Mandate Id',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].mandate_id,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
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
                                              getProportionateScreenHeight(40),
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
                                              _progress = 0;
                                              _timer?.cancel();
                                              _timer = Timer.periodic(
                                                  const Duration(
                                                      milliseconds: 10),
                                                  (Timer timer) async {
                                                await EasyLoading.showProgress(
                                                    _progress,
                                                    status:
                                                        '${(_progress * 100).toStringAsFixed(0)}%');
                                                _progress += 0.03;
                                                if (_progress >= 1) {
                                                  _timer?.cancel();
                                                  EasyLoading.dismiss();
                                                }
                                              });
                                              Navigator.pop(context);
                                              setState(() {
                                                _getBankDetail();
                                              });
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
