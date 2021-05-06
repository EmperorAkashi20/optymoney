import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/size_config.dart';

import '../../constants.dart';

class Body extends StatefulWidget {
  static var offerId = 32;
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

  Future<List<GetIndiScheme>> _getScheme() async {
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
    print(schemeBody);
    var jsonData = json.decode(schemeBody);
    print(jsonData);
    var len = jsonData.length;
    print('Length');
    print(len);
    //print(jsonData[])
    // var parsedNav = json.decode(jsonData['nav_price']);
    //print("object");
    //print(parsedNav);
    List<GetIndiScheme> getIndiSchemes = [];
    for (var sch in jsonData) {
      var a = json.encode(sch['nav_price']);
      print(a);
      var b = json.decode(a);
      print(b);
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
        sch['nav_price'],
      );
      if (sch['pk_nav_id'] != null) {
        print(sch['pk_nav_id']);
        print(sch['scheme_code']);
        print(sch['unique_no']);

        //print(sch['nav_price']);
      }
      getIndiSchemes.add(getIndiScheme);
    }
    return getIndiSchemes;
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dropDownStringItem),
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
                    print("aaa");
                    print(Body.offerId);
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
          future: _getScheme(),
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
                        //duration: Duration(milliseconds: 500),
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
                      left: 10.0,
                      right: 10.0,
                      top: 5,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: getProportionateScreenHeight(120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: kPrimaryColor, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    snapshot.data[index].scheme_name,
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.left,
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
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Nav'),
                                  Text(
                                    snapshot.data[index].nav_price,
                                  ),
                                ],
                              ),
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
  final String nav_price;

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
    this.nav_price,
  );
}