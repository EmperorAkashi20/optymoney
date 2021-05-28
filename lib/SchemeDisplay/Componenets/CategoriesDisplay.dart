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
  static var alen;
  static var b;
  static var c;

  @override
  _CategoriesDsiplayState createState() => _CategoriesDsiplayState();
}

class _CategoriesDsiplayState extends State<CategoriesDsiplay> {
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

    var schemeBody = response.body;
    var jsonData = json.decode(schemeBody);
    print(jsonData);
    print('a');
    var a = jsonData['EQUITY'].toString();
    print(a);
    print('b');
    var b = jsonData['ELSS'].toString();
    print(b);
    var c = jsonData['EQUITY']['value'];
    print(c);
    var d = c.length;
    print(d);
    for (var a in c) {
      print(a['id']);
    }

    List<CategoryFiltersList> categoryFiltersLists = [];
    for (var sch in jsonData) {
      // String credentials = sch['isin'];
      // Codec<String, String> stringToBase64 = utf8.fuse(base64);
      // Body.encoded =
      //     stringToBase64.encode(credentials); // dXNlcm5hbWU6cGFzc3dvcmQ=

      CategoryFiltersList categoryFiltersList = CategoryFiltersList(
        sch['EQUITY'],
        sch['ELSS'],
        sch['HYBRID'],
        sch['DEBT'],
        sch['FOF'],
      );

      categoryFiltersLists.add(categoryFiltersList);
      CategoriesDsiplay.userStatus.add(false);
    }

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
              itemCount: CategoriesDsiplay.alen,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Text(snapshot.data[index].EQUITY),
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
}
