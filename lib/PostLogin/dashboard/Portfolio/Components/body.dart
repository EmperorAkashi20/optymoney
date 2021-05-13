import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:optymoney/UserInfo/UserInfoStartScreen.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:optymoney/size_config.dart';

makeUserRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=getCustomerInfo&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
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

  print("aaa");
  Body.statusCode = response.statusCode;
  Body.responseBody = response.body;
  print(Body.responseBody);
  var jsonData = Body.responseBody;

  var parsedJson = json.decode(jsonData);
  Body.userId = parsedJson['pk_user_id'].toString();
  // print(Body.userId);
  Body.emailId = parsedJson['login_id'].toString();
  // print(Body.emailId);
  Body.custId = parsedJson['fr_customer_id'].toString();
  // print(Body.custId);
  Body.custName = parsedJson['cust_name'].toString();
  // print(Body.custName);
  Body.custPan = parsedJson['pan_number'].toString();
  print('pan:' + Body.custPan);
  Body.custLetter = Body.custName[0].toUpperCase();
  // print(Body.custLetter);
  Body.custBday = parsedJson['dob'].toString();
  // print(Body.custBday);
  Body.custAddress1 = parsedJson['address1'].toString();
  Body.custAddress2 = parsedJson['address2'].toString();
  Body.custAddress3 = parsedJson['address3'].toString();
  Body.custMobile = parsedJson['contact_no'].toString();
  Body.custState = parsedJson['state'].toString();
  Body.custCity = parsedJson['city'].toString();
  Body.custPinCode = parsedJson['pincode'].toString();
  Body.custCountry = parsedJson['country'].toString();
  SignForm.email1 = Body.emailId;
  SignForm.name = Body.custName;
  SignForm.letter = Body.custLetter;
  SignForm.userBday = Body.custBday;
  SignForm.userAddress1 = Body.custAddress1;
  SignForm.userAddress2 = Body.custAddress2;
  SignForm.userAddress3 = Body.custAddress3;
  SignForm.userMobile = Body.custMobile;
  SignForm.userState = Body.custState;
  SignForm.userCity = Body.custCity;
  SignForm.userPinCode = Body.custPinCode;
  SignForm.userCountry = Body.custCountry;
}

class Body extends StatefulWidget {
  static double purchasePrice = 0.0;
  static var statusCode;
  static var responseBody;
  static var userId;
  static var emailId;
  static var custId;
  static var custName;
  static var custPan;
  static var custLetter;
  static var custBday;
  static var custAddress1;
  static var custAddress2;
  static var custAddress3;
  static var custMobile;
  static var custState;
  static var custCity;
  static var custPinCode;
  static var custCountry;
  static var purPrice = 0.0;
  static var profitLoss = 0.0;
  static var presentVal = 0.0;
  static var amount;
  static var allUnits;
  static var navPrice;
  static var presentValIndi;
  static var flag = 0;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Scheme>> _getScheme() async {
    var url = Uri.parse(
        'https://optymoney.com/ajax-request/ajax_response.php?action=fetchPortfolioApp&subaction=submit');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'uid': SignForm.userIdGlobal,
      'pan': SignForm.pan,
    };
    //String jsonBody = json.encode(body);
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
    var len = jsonData.length;
    print("Length");
    print(len);
    List<Scheme> schemes = [];
    Body.purPrice = 0.0;
    Body.presentVal = 0.0;
    print("1");
    for (var sch in jsonData) {
      var a = sch['nav_price'] * sch['all_units'];
      //  Scheme(this.isin, this.folio, this.bse_scheme_code, this.fr_scheme_name,
      // this.purchase_price, this.scheme_type, this.amount, this.all_units);

      Scheme scheme = Scheme(
          sch['isin'],
          sch['folio'],
          sch['bse_scheme_code'],
          sch['fr_scheme_name'],
          sch['purchase_price'],
          sch['nav_price'], // sch['nav_price'],
          sch['scheme_type'],
          sch['amount'].toDouble(),
          sch['all_units'].toDouble(),
          a.toDouble().round());
      // print(scheme.toString());
      //
      if (sch['all_units'] != 0) {
        print(sch['amount']);
        print(sch['all_units']);
        print(sch['nav_price']);
      }

      //print(scheme.sch_amount);
      if (sch['all_units'].toDouble() == 0 || sch['all_units'].toDouble() < 0) {
        // sch++;
      } else {
        schemes.add(scheme);
        Body.presentVal =
            Body.presentVal + (sch['nav_price'] * sch['all_units']);
        Body.purPrice = Body.purPrice + sch['amount'].toDouble();
        Body.navPrice = sch['nav_price'].toDouble();
        Body.presentValIndi = sch['nav_price'] * sch['all_units'];
        //Body.purchasePrice = sch['purchase_price'].toDouble();
      }
    }
    print(Body.presentVal);
    Body.profitLoss = Body.presentVal - Body.purPrice;
    return schemes;
  }

  @override
  void initState() {
    super.initState();
    makeUserRequest();
    //makePortfolioRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      //CircularProgressIndicator.adaptive(),
                      LoadingDoubleFlipping.circle(
                        borderColor: kPrimaryColor,
                        borderSize: 2.0,
                        size: 40.0,
                        backgroundColor: kPrimaryColor,
                        //duration: Duration(milliseconds: 500),
                      ),
                      Text(
                        "We are fetching your profits...\nHOLD TIGHT!!",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Container(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //CircularProgressIndicator.adaptive(),
                    if (Body.custPan == 'null')
                      Container(
                        width: double.infinity,
                        height: getProportionateScreenHeight(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: kPrimaryColor, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Profile Incomplete"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("To Complete your profile: "),
                                Text("1. Keep Your documents handy"),
                                Text(
                                    "2. Tap on the menu on the top left corner"),
                                Text("3. Enter details and verify"),
                                Text("\n\nOr tap on \"complete Now\" below"),
                                TextButton(
                                  child: Text("Complete Now"),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, UserInfoScreen.routeName);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (Body.custPan != 'null')
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: double.infinity,
                              height: getProportionateScreenHeight(120),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kPrimaryColor, width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'This is an example company',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.left,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.grey.shade200,
                                          child: Icon(Icons.add_chart),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Purchase Price",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "₹ 1234",
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Investment",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "₹ 12340",
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Present Value",
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "₹ 123400",
                                                  style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_upward_sharp,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: double.infinity,
                              height: getProportionateScreenHeight(120),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kPrimaryColor, width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Start Your Investments"),
                                  Text(
                                      "Content will start appearing once you invest"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                  ],
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
                                    snapshot.data[index].fr_scheme_name,
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
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 20,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.add_chart,
                                          color: Colors.blueGrey,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            //expand: false,
                                            enableDrag: true,
                                            isDismissible: true,
                                            //duration: Duration(milliseconds: 400),
                                            context: context,
                                            //isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            builder: (context) => Scaffold(
                                              body: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .analytics_sharp,
                                                            size: 35,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 7,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 8.0,
                                                            ),
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .fr_scheme_name,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: CloseButton(),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        DataDisplayScheme(
                                                          data1: "ISIN",
                                                          data2: snapshot
                                                              .data[index].isin,
                                                        ),
                                                        DataDisplayScheme(
                                                          data1: "Scheme Code",
                                                          data2: snapshot
                                                              .data[index]
                                                              .bse_scheme_code
                                                              .toString(),
                                                        ),
                                                        DataDisplayScheme(
                                                          data1: "Scheme Type",
                                                          data2: snapshot
                                                              .data[index]
                                                              .scheme_type
                                                              .toString(),
                                                        ),
                                                        DataDisplayScheme(
                                                          data1:
                                                              "Purchase Price",
                                                          data2: snapshot
                                                              .data[index]
                                                              .purchase_price
                                                              .toString(),
                                                        ),
                                                        DataDisplayScheme(
                                                          data1: "Total Units",
                                                          data2: snapshot
                                                              .data[index]
                                                              .all_units
                                                              .toString(),
                                                        ),
                                                        DataDisplayScheme(
                                                          data1:
                                                              "Current Amount",
                                                          data2: snapshot
                                                              .data[index]
                                                              .sch_amount
                                                              .toString(),
                                                        ),
                                                        DataDisplayScheme(
                                                          data1: "Nav Amount",
                                                          data2: snapshot
                                                              .data[index]
                                                              .nav_price
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      //Buying and Selling Buttons
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blueAccent,
                                                            ),
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    40),
                                                            width:
                                                                getProportionateScreenWidth(
                                                                    140),
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .swap_vert_circle_sharp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Text(
                                                                    "BUY",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    40),
                                                            width:
                                                                getProportionateScreenWidth(
                                                                    140),
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .swap_vertical_circle_sharp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Text(
                                                                    "SELL",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Purchase Price",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "₹" +
                                            snapshot.data[index].purchase_price
                                                .toString(),
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Investment",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "₹" +
                                            snapshot.data[index].sch_amount
                                                .toDouble()
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Present Value",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹" +
                                                snapshot.data[index].presentVal
                                                    .toString(),
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if ((snapshot.data[index].sch_amount
                                                  .toDouble()
                                                  .round()) <
                                              (snapshot.data[index].presentVal
                                                  .toDouble()
                                                  .round()))
                                            Icon(
                                              Icons.arrow_upward_sharp,
                                              size: 16,
                                            ),
                                          if (snapshot.data[index].sch_amount
                                                  .toDouble()
                                                  .round() >
                                              snapshot.data[index].presentVal
                                                  .toDouble()
                                                  .round())
                                            Icon(
                                              Icons.arrow_downward_sharp,
                                              size: 16,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Expanded(
                            //         child:
                            //             Text(snapshot.data[index].scheme_type)),
                            //     Expanded(
                            //         child: Text(snapshot.data[index].all_units
                            //             .toString())),
                            //     Expanded(
                            //       child: Text(snapshot.data[index].sch_amount
                            //           .toString()),
                            //     ),
                            //     Expanded(
                            //       child: Text(snapshot
                            //           .data[index].purchase_price
                            //           .toString()),
                            //     ),
                            //   ],
                            // ),
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

class DataDisplayScheme extends StatelessWidget {
  const DataDisplayScheme({
    Key? key,
    required this.data1,
    required this.data2,
  }) : super(key: key);

  final String data1;
  final String data2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            data1,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            data2,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class Scheme {
  final String isin;
  final String folio;
  // ignore: non_constant_identifier_names
  final String bse_scheme_code;
  // ignore: non_constant_identifier_names
  final String fr_scheme_name;
  // ignore: non_constant_identifier_names
  var purchase_price;
  // ignore: non_constant_identifier_names
  var nav_price;
  var presentVal;
  // ignore: non_constant_identifier_names
  final double sch_amount;
  // ignore: non_constant_identifier_names
  final double all_units;
  // ignore: non_constant_identifier_names
  final String scheme_type;

  Scheme(
    this.isin,
    this.folio,
    this.bse_scheme_code,
    this.fr_scheme_name,
    this.purchase_price,
    this.nav_price,
    this.scheme_type,
    this.sch_amount,
    this.all_units,
    this.presentVal,
  );
}
