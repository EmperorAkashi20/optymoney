import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AllSchemeDisplay.dart';
import 'package:optymoney/SchemeDisplay/Componenets/CategoriesDisplay.dart';
import 'package:optymoney/SchemeDisplay/schemedisplay.dart';
import 'package:optymoney/size_config.dart';

import '../../constants.dart';

class AmcFilters extends StatefulWidget {
  static List selecteCategorys = [];
  static var testVar;
  @override
  _AmcFiltersState createState() => _AmcFiltersState();
}

class _AmcFiltersState extends State<AmcFilters> {
  var userStatus = <bool>[];
  bool selected = false;

  Future<List<AmcDetails>> makeAmcRequest() async {
    var url = Uri.parse(
        'https://optymoney.com/__lib.ajax/ajax_response.php?action=amccodes&subaction=submit');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {};
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    var dataBody = response.body;
    var jsonData = json.decode(dataBody);
    //print(jsonData);
    List<AmcDetails> amcDetailss = [];

    for (var sch in jsonData) {
      AmcDetails amcDetails = AmcDetails(
        sch['mf_schema_id'],
        sch['amc_name_act'],
      );
      if (sch['mf_schema_id'] != null) {}
      amcDetailss.add(amcDetails);
      userStatus.add(false);
    }
    return amcDetailss;
  }

  @override
  void initState() {
    super.initState();
    AmcFilters.selecteCategorys = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: makeAmcRequest(),
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
            return Column(
              children: [
                Expanded(
                  flex: 8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(snapshot.data[index].amc_name_act),
                        value: userStatus[index],
                        onChanged: (val) {
                          setState(() {
                            userStatus[index] = !userStatus[index];
                            if (userStatus[index] == true) {
                              AmcFilters.selecteCategorys
                                  .add(snapshot.data[index].mf_schema_id);
                            } else if (userStatus[index] == false) {
                              AmcFilters.selecteCategorys
                                  .remove(snapshot.data[index].mf_schema_id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: getProportionateScreenHeight(20),
                    width: double.infinity,
                    color: kPrimaryColor,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pop(context);
                        print(AmcFilters.selecteCategorys);
                        await getSchemeListRequest(AmcFilters.selecteCategorys,
                            CategoriesDsiplay.selectedCategories);
                        Navigator.pushNamed(
                            context, PostLoginStartsHere.routeName);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => AllSchemeDisplay.routeName()),
                        // );
                      },
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AmcDetails {
  // ignore: non_constant_identifier_names
  final String mf_schema_id;
  // ignore: non_constant_identifier_names
  final String amc_name_act;

  AmcDetails(this.mf_schema_id, this.amc_name_act);
}
