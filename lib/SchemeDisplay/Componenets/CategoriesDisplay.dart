import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';

import '../../constants.dart';

class CategoriesDsiplay extends StatefulWidget {
  static var userStatus = <bool>[];
  static var pName;
  static var cName;
  static var id;
  static var keys;
  static var values;

  @override
  _CategoriesDsiplayState createState() => _CategoriesDsiplayState();
}

class _CategoriesDsiplayState extends State<CategoriesDsiplay> {
  bool value = false;
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
            return ListView.builder(
              itemCount: CategoriesDsiplay.keys.length,
              itemBuilder: (BuildContext context, int index) {
                String key = CategoriesDsiplay.keys.elementAt(index);
                String values =
                    CategoriesDsiplay.values.elementAt(index).toString();
                print(key);
                return Column(
                  children: [
                    new ExpansionTile(
                      title: Text('$key'),
                      children: [
                        Text((CategoriesDsiplay.values[index]['value'])
                            .toString()),
                        //json.decode(CategoriesDsiplay.values[index].toString()),
                      ],
                      // subtitle: Text('$values'.toString()),
                    ),
                  ],
                );
              },
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
