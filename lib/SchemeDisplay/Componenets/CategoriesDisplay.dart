import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AllSchemeDisplay.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AmcFilters.dart';

import '../../constants.dart';
import '../../size_config.dart';

class CategoriesDsiplay extends StatefulWidget {
  static List selectedCategories = [];
  static var keys;
  static var values;

  @override
  _CategoriesDsiplayState createState() => _CategoriesDsiplayState();
}

class _CategoriesDsiplayState extends State<CategoriesDsiplay> {
  bool selected = false;
  var userStatus = <bool>[];
  var selectAll = <bool>[];
  final allCheckbox = CategoryFilters(title: 'SELECT ALL');
  Future<List<CategoryFiltersList>> getCategoryList() async {
    var url = Uri.parse(
        'https://optymoney.com/__lib.ajax/ajax_response.php?action=schemetypelist&subaction=submit');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'st_search': '',
    };
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<CategoryFiltersList> categoryFiltersLists = [];
    jsonResponse.forEach((key, value) {
      CategoryFiltersList categoryFiltersList =
          CategoryFiltersList.fromJson(jsonResponse);

      CategoriesDsiplay.keys = jsonResponse.keys.toList();
      CategoriesDsiplay.values = jsonResponse.values.toList();
      categoryFiltersLists.add(categoryFiltersList);
    });

    return categoryFiltersLists;
  }

  @override
  void initState() {
    super.initState();
    CategoriesDsiplay.selectedCategories = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getCategoryList(),
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
                    itemCount: CategoriesDsiplay.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      var key = CategoriesDsiplay.keys.elementAt(index);
                      var values = CategoriesDsiplay.values.elementAt(index);
                      var sch = values['value'];
                      var sch1 = sch;
                      selectAll.add(false);
                      return Column(
                        children: [
                          ExpansionTile(
                            title: Text('$key'),
                            children: [
                              CheckboxListTile(
                                title: Text('SELECT ALL'),
                                value: selectAll[index],
                                onChanged: (val) {
                                  setState(() {
                                    selectAll[index] = !selectAll[index];
                                    if (selectAll[index] == true) {
                                      for (int i = 0; i < sch.length; i++) {
                                        userStatus[i] = (true);
                                        CategoriesDsiplay.selectedCategories
                                            .add(sch1[i]['id']);
                                        print(CategoriesDsiplay
                                            .selectedCategories);
                                      }
                                    }
                                    if (selectAll[index] == false) {
                                      for (int i = 0; i < sch.length; i++) {
                                        userStatus[i] = (false);
                                        CategoriesDsiplay.selectedCategories
                                            .remove(sch1[i]['id']);
                                        print(CategoriesDsiplay
                                            .selectedCategories);
                                      }
                                    }
                                  });
                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: sch.length,
                                itemBuilder: (context, index) {
                                  userStatus.add(false);
                                  return CheckboxListTile(
                                    title: Text(sch1[index]['name'].toString()),
                                    value: userStatus[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        //selected = !selected;
                                        userStatus[index] = !userStatus[index];
                                        if (userStatus[index] == true) {
                                          CategoriesDsiplay.selectedCategories
                                              .add(sch1[index]['id']);
                                          print(CategoriesDsiplay
                                              .selectedCategories);
                                        } else if (userStatus[index] == false) {
                                          CategoriesDsiplay.selectedCategories
                                              .remove(sch1[index]['id']);
                                          print(CategoriesDsiplay
                                              .selectedCategories);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
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
                        Navigator.pop(context);
                        print(CategoriesDsiplay.selectedCategories);
                        await getSchemeListRequest(AmcFilters.selecteCategorys,
                            CategoriesDsiplay.selectedCategories);
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

class CategoryFiltersList {
  // ignore: non_constant_identifier_names
  var EQUITY;
  // ignore: non_constant_identifier_names
  var ELSS;
  // ignore: non_constant_identifier_names
  var HYBRID;
  // ignore: non_constant_identifier_names
  var DEBT;
  // ignore: non_constant_identifier_names
  var FOF;

  CategoryFiltersList(
    this.EQUITY,
    this.ELSS,
    this.HYBRID,
    this.DEBT,
    this.FOF,
  );

  Map<String, dynamic> toJson() => {
        'EQUITY': EQUITY,
        'ELSS': ELSS,
        'HYBRID': HYBRID,
        'DEBT': DEBT,
        'FOF': FOF,
      };

  // for init from a json object.
  CategoryFiltersList.fromJson(Map<String, dynamic> json)
      : EQUITY = json['EQUITY'],
        ELSS = json['ELSS'],
        HYBRID = json['HYBRID'],
        DEBT = json['DEBT'],
        FOF = json['FOF'];
}

class CategoryFilters {
  final String title;
  bool value;

  CategoryFilters({
    required this.title,
    this.value = false,
  });
}

class SingleValues {
  var name;
  var id;

  SingleValues(
    this.name,
    this.id,
  );
}
