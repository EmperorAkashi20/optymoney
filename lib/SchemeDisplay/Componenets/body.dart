import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/PostLogin/investments/components/body.dart';
import 'package:optymoney/SchemeDisplay/Componenets/LumpSumDisplay.dart';
import 'package:optymoney/SchemeDisplay/Componenets/SipDisplay.dart';
import 'package:optymoney/size_config.dart';

import '../../constants.dart';

class Body extends StatefulWidget {
  static var offerId = 32;
  static var encoded;
  static var netAsset;
  static var priceDate;
  static var priceList;
  static var dateList;
  static var i;
  static var id;
  static var minAmt;
  static var maxAmt;
  static var values;
  static var lumpSumMin;
  static var lumpSumMax;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var _options = [
    'Best Performing Mutual Funds',
    'Best Equity Mutual Funds',
    'Best Liquid Funds',
    'Top SIP Funds',
    'Best ELSS Funds',
    'Best Large Cap Funds',
    'Explore Funds',
    'Best Mid Cap Funds',
    'New To Mutual Funds'
  ];
  String _currentItemSelected = 'Best Performing Mutual Funds';

  Future<List<GetIndiScheme>> getScheme() async {
    var url = Uri.parse('https://optymoney.com/__lib.ajax/ajax_response.php');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'filter_offer_search_app': 'yes',
      'offer_id': Body.offerId.toString(),
    };
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    var schemeBody = response.body;
    var jsonData = json.decode(schemeBody);

    List<GetIndiScheme> getIndiSchemes = [];
    for (var sch in jsonData) {
      var a = (sch['nav_price']);
      var nav1 = a['1'];
      var nav2 = a['3'];
      var nav3 = a['5'];
      String credentials = sch['isin'];
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      Body.encoded =
          stringToBase64.encode(credentials); // dXNlcm5hbWU6cGFzc3dvcmQ=

      GetIndiScheme getIndiScheme = GetIndiScheme(
        sch['pk_nav_id'],
        sch['scheme_code'],
        sch['unique_no'],
        sch['rta_scheme_code'],
        sch['amc_scheme_code'],
        sch['isin'],
        sch['scheme_type'],
        sch['scheme_plan'],
        sch['scheme_name'],
        nav1.toString(),
        nav2.toString(),
        nav3.toString(),
        Body.encoded,
        //makeGraph(Body.encoded.toString()),
      );
      if (sch['pk_nav_id'] != null) {}

      //print(Body.encoded);
      getIndiSchemes.add(getIndiScheme);
      //print(getIndiScheme.encodedIsin);
    }

    return getIndiSchemes;
  }

  makeSipRequest(pknavid) async {
    var url = Uri.parse('https://optymoney.com/__lib.ajax/ajax_response.php');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'fetch_sch': pknavid,
      'get_scheme_data': 'yes',
    };
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    var dataBody = response.body;
    var jsonData = json.decode(dataBody);
    Body.minAmt =
        double.tryParse(jsonData[0]['sip_minimum_installment_amount']);
    Body.maxAmt =
        double.tryParse(jsonData[0]['sip_maximum_installment_amount']);
    Body.id = jsonData[0]['pk_nav_id'];

    Body.lumpSumMin = double.tryParse(jsonData[0]['minimum_purchase_amount']);
    Body.lumpSumMax = double.tryParse(jsonData[0]['maximum_purchase_amount']);
    if (Body.lumpSumMin == Body.lumpSumMax) {
      Body.lumpSumMin = 0.0;
      Body.lumpSumMax = 99999999.0;
    }
    if (Body.minAmt == Body.maxAmt) {
      Body.minAmt = 0.0;
      Body.maxAmt = 99999999.0;
    }
    Body.values = Body.minAmt;
  }

  @override
  void initState() {
    super.initState();
    Body.offerId = 32;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: Container(
            width: double.infinity,
            height: getProportionateScreenHeight(120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kPrimaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey.shade200,
                  isExpanded: true,
                  elevation: 0,
                  items: _options.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dropDownStringItem,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Divider(
                            thickness: 0.4,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValueSelected) {
                    _dropDownItemSelected(newValueSelected);
                    //Body.offerId = _currentItemSelected;

                    if (_currentItemSelected ==
                        'Best Performing Mutual Funds') {
                      Body.offerId = 32;
                    } else if (_currentItemSelected ==
                        'Best Equity Mutual Funds') {
                      Body.offerId = 33;
                    } else if (_currentItemSelected == 'Best Liquid Funds') {
                      Body.offerId = 34;
                    } else if (_currentItemSelected == 'Top SIP Funds') {
                      Body.offerId = 35;
                    } else if (_currentItemSelected == 'Best ELSS Funds') {
                      Body.offerId = 36;
                    } else if (_currentItemSelected == 'Best Large Cap Funds') {
                      Body.offerId = 37;
                    } else if (_currentItemSelected == 'Explore Funds') {
                      Body.offerId = 38;
                    } else if (_currentItemSelected == 'Best Mid Cap Funds') {
                      Body.offerId = 39;
                    } else if (_currentItemSelected == 'New To Mutual Funds') {
                      Body.offerId = 40;
                    }
                  },
                  value: _currentItemSelected,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getScheme(),
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
                      Text(
                        "We are fetching the best schemes for you...\nHOLD TIGHT!!",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: kPrimaryColor),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].scheme_name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(100),
                                        height:
                                            getProportionateScreenHeight(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: kPrimaryColor,
                                              width: 0.28),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data[index].scheme_type,
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: kPrimaryColor,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 20,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_chart,
                                          color: Colors.blueGrey,
                                        ),
                                        onPressed: () async {
                                          await makeSipRequest(
                                              snapshot.data[index].pk_nav_id);
                                          showModalBottomSheet(
                                            isDismissible: true,
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) =>
                                                DefaultTabController(
                                              length: 2,
                                              child: Scaffold(
                                                appBar: AppBar(
                                                  bottom: TabBar(
                                                    tabs: [
                                                      InvestmentTabs(
                                                          title: 'SIP'),
                                                      InvestmentTabs(
                                                          title: 'One Time'),
                                                    ],
                                                    unselectedLabelColor:
                                                        kPrimaryColor,
                                                    indicator: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: kPrimaryColor),
                                                    indicatorSize:
                                                        TabBarIndicatorSize
                                                            .label,
                                                  ),
                                                  automaticallyImplyLeading:
                                                      false,
                                                  flexibleSpace: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 7,
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .scheme_name,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Expanded(
                                                              flex: 1,
                                                              child:
                                                                  CloseButton()),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                body: TabBarView(
                                                  children: [
                                                    SipDisplay(),
                                                    LumpSumDisplay(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "1 Year",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data[index].nav_price1 + "%",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "3 Years",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data[index].nav_price2 + "%",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "5 Years",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data[index].nav_price3 + "%",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
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
              );
            }
          },
        ),
      ),
    );
  }

  void _dropDownItemSelected(String? newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected.toString();
    });
  }
}

class CreateDataList {
  var price;
  var date;

  CreateDataList(this.price, this.date);
}

class GetIndiScheme {
  // ignore: non_constant_identifier_names
  final String pk_nav_id;
  // ignore: non_constant_identifier_names
  final String unique_no;
  // ignore: non_constant_identifier_names
  final String scheme_code;
  // ignore: non_constant_identifier_names
  final String rta_scheme_code;
  // ignore: non_constant_identifier_names
  final String amc_scheme_code;
  // ignore: non_constant_identifier_names
  final String isin;
  // ignore: non_constant_identifier_names
  final String scheme_type;
  // ignore: non_constant_identifier_names
  final String scheme_plan;
  // ignore: non_constant_identifier_names
  final String scheme_name;
  // ignore: non_constant_identifier_names
  final String nav_price1;
  // ignore: non_constant_identifier_names
  final String nav_price2;
  // ignore: non_constant_identifier_names
  final String nav_price3;
  final String encodedIsin;
  //Future makeGraph;

  GetIndiScheme(
    this.pk_nav_id,
    this.scheme_code,
    this.unique_no,
    this.rta_scheme_code,
    this.amc_scheme_code,
    this.isin,
    this.scheme_type,
    this.scheme_plan,
    this.scheme_name,
    this.nav_price1,
    this.nav_price2,
    this.nav_price3,
    this.encodedIsin,
    //this.makeGraph,
  );
}
