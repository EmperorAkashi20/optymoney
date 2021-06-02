import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/PostLogin/investments/components/body.dart';
import 'package:optymoney/SchemeDisplay/Componenets/AmcFilters.dart';
import 'package:optymoney/SchemeDisplay/Componenets/CategoriesDisplay.dart';
import 'package:optymoney/SchemeDisplay/Componenets/LumpSumDisplayFilters.dart';
import 'package:optymoney/SchemeDisplay/Componenets/SipDisplayFilters.dart';

import '../../constants.dart';
import '../../size_config.dart';

class AllSchemeDisplay extends StatefulWidget {
  static String routeName = '\allScheme';
  static var test;
  static var encoded;
  static var minAmt;
  static var maxAmt;
  static var values;
  static var lumpSumMin;
  static var lumpSumMax;
  static var id;

  @override
  _AllSchemeDisplayState createState() => _AllSchemeDisplayState();
}

Future<List<AllSchemeWithFilters>> getSchemeListRequest(List a, List b) async {
  print(AmcFilters.selecteCategorys);
  print(CategoriesDsiplay.selectedCategories);
  var url = Uri.parse(
      'https://optymoney.com/__lib.ajax/ajax_response.php?action=filter_offer_search_app_test1');
  final headers = {'Content-Type': 'application/json'};

  var body = jsonEncode({
    "amc_code": AmcFilters.selecteCategorys,
    "schm_type": "",
    "Offer_id": 5,
  });

  Response response = await post(
    url,
    headers: headers,
    body: body,
  );
  var dataBody = response.body;
  var jsonData = json.decode(dataBody);
  List<AllSchemeWithFilters> allSchemeWithFilterss = [];

  for (var sch in jsonData) {
    var a = (sch['nav_price']);
    var nav1 = a['1'];
    var nav2 = a['3'];
    var nav3 = a['5'];
    String credentials = sch['isin'];
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    AllSchemeDisplay.encoded = stringToBase64.encode(credentials);
    AllSchemeWithFilters allSchemeWithFilters = AllSchemeWithFilters(
      sch['pk_nav_id'],
      sch['unique_no'],
      sch['scheme_name'],
      sch['scheme_type'],
      sch['scheme_code'],
      sch['rta_scheme_code'],
      sch['amc_scheme_code'],
      sch['isin'],
      sch['scheme_plan'],
      nav1.toString(),
      nav2.toString(),
      nav3.toString(),
      AllSchemeDisplay.encoded,
    );
    if (sch['pk_nav_id'] != null) {}
    allSchemeWithFilterss.add(allSchemeWithFilters);
  }
  return allSchemeWithFilterss;
}

makeSipRequestFilters(pknavid) async {
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
  AllSchemeDisplay.minAmt =
      double.tryParse(jsonData[0]['sip_minimum_installment_amount']);
  AllSchemeDisplay.maxAmt =
      double.tryParse(jsonData[0]['sip_maximum_installment_amount']);
  AllSchemeDisplay.id = jsonData[0]['pk_nav_id'];
  AllSchemeDisplay.lumpSumMin =
      double.tryParse(jsonData[0]['minimum_purchase_amount']);
  AllSchemeDisplay.lumpSumMax =
      double.tryParse(jsonData[0]['maximum_purchase_amount']);
  if (AllSchemeDisplay.lumpSumMin == AllSchemeDisplay.lumpSumMax) {
    AllSchemeDisplay.lumpSumMin = 0.0;
    AllSchemeDisplay.lumpSumMax = 99999999.0;
  }
  if (AllSchemeDisplay.minAmt == AllSchemeDisplay.maxAmt) {
    AllSchemeDisplay.minAmt = 0.0;
    AllSchemeDisplay.maxAmt = 99999999.0;
  }
  AllSchemeDisplay.values = AllSchemeDisplay.minAmt;
}

class _AllSchemeDisplayState extends State<AllSchemeDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CategoryAndFilters(
                  title: 'Categories',
                  widgetBody: CategoriesDsiplay(),
                ),
              ),
              Expanded(
                flex: 1,
                child: CategoryAndFilters(
                  title: 'AMC Filters',
                  widgetBody: AmcFilters(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getSchemeListRequest(AmcFilters.selecteCategorys,
              CategoriesDsiplay.selectedCategories),
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
                key: UniqueKey(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: kPrimaryColor),
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
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: () async {
                                        await makeSipRequestFilters(
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
                                                          BorderRadius.circular(
                                                              50),
                                                      color: kPrimaryColor),
                                                  indicatorSize:
                                                      TabBarIndicatorSize.label,
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
                                                            snapshot.data[index]
                                                                .scheme_name,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
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
                                                  SipDisplayFilters(),
                                                  LumpSumDisplayFilters(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add_chart,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
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
}

class CategoryAndFilters extends StatelessWidget {
  const CategoryAndFilters({
    required this.widgetBody,
    required this.title,
    Key? key,
  }) : super(key: key);

  final Widget widgetBody;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: getProportionateScreenHeight(120),
        width: getProportionateScreenWidth(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kPrimaryColor),
        ),
        child: TextButton(
          child: Text(title),
          onPressed: () {
            showModalBottomSheet(
              isDismissible: true,
              enableDrag: true,
              context: context,
              builder: (context) => Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(title),
                  actions: [CloseButton()],
                ),
                body: widgetBody,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AllSchemeWithFilters {
  // ignore: non_constant_identifier_names
  final String pk_nav_id;
  // ignore: non_constant_identifier_names
  var unique_no;
  // ignore: non_constant_identifier_names
  var scheme_name;
  // ignore: non_constant_identifier_names
  var scheme_type;
  // ignore: non_constant_identifier_names
  var scheme_code;
  // ignore: non_constant_identifier_names
  var rta_scheme_code;
  // ignore: non_constant_identifier_names
  var amc_scheme_code;
  var isin;
  // ignore: non_constant_identifier_names
  var scheme_plan;
  // ignore: non_constant_identifier_names
  var nav_price1;
  // ignore: non_constant_identifier_names
  var nav_price2;
  // ignore: non_constant_identifier_names
  var nav_price3;
  var encodedIsin;

  AllSchemeWithFilters(
    this.pk_nav_id,
    this.unique_no,
    this.scheme_name,
    this.scheme_type,
    this.scheme_code,
    this.rta_scheme_code,
    this.amc_scheme_code,
    this.isin,
    this.scheme_plan,
    this.nav_price1,
    this.nav_price2,
    this.nav_price3,
    this.encodedIsin,
  );
}
