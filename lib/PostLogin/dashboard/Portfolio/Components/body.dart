import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/PostLogin/postloginstartshere.dart';
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
  // print(Body.custPan);
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

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Scheme>> _getScheme() async {
    var url = Uri.parse(
        'https://optymoney.com/ajax-request/ajax_response.php?action=fetchPortfolioApp&subaction=submit');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'uid': SignForm.userId,
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
    // Body.allUnits = 0.0;
    print("1");
    for (var sch in jsonData) {
      //  Scheme(this.isin, this.folio, this.bse_scheme_code, this.fr_scheme_name,
      // this.purchase_price, this.scheme_type, this.amount, this.all_units);
      var x = sch['nav_price'] * sch['all_units'];
      Scheme scheme = Scheme(
          sch['isin'],
          sch['folio'],
          sch['bse_scheme_code'],
          sch['fr_scheme_name'],
          sch['purchase_price'],
          sch['nav_price'],
          sch['scheme_type'],
          sch['amount'].toDouble(),
          sch['all_units'].toDouble(),
          x);
      print(sch['amount']);
      print(sch['all_units']);
      print(sch['nav_price']);
      Body.purPrice = Body.purPrice + sch['amount'].toDouble();
      //print(scheme.sch_amount);
      if (sch['all_units'].toDouble() == 0 || sch['all_units'].toDouble() < 0) {
        // sch++;
      } else {
        Body.presentVal =
            Body.presentVal + (sch['nav_price'] * sch['all_units']);
        schemes.add(scheme);
      }
      print(Body.presentVal);
      print(sch['nav_price']);
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
                      CircularProgressIndicator.adaptive(),
                      Text("Loading..."),
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
                      //CircularProgressIndicator.adaptive(),
                      if (Body.custPan == 'null')
                        AlertDialog(
                          title: Text("Profile Incomplete"),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To Complete your profile: "),
                              Text("1. Keep Your documents handy"),
                              Text("2. Tap on the menu on the top left corner"),
                              Text("3. Enter details and verify"),
                              Text("\n\nOr tap on \"complete Now\" below"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text("Complete Now"),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, UserInfoScreen.routeName);
                              },
                            ),
                          ],
                        ),
                      if (Body.custPan != 'null')
                        AlertDialog(
                          title: Text("Start Your Investments"),
                          content: Text(
                              "Content will start appearing once you invest"),
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
                      left: 3.0,
                      right: 3,
                      top: 5,
                    ),
                    child: Card(
                      elevation: 5,
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
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.login,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        450),
                                                width:
                                                    getProportionateScreenWidth(
                                                        350),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 8.0,
                                                      ),
                                                      child: Text(
                                                        snapshot.data[index]
                                                            .fr_scheme_name,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
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
                                                          data1: "Nav",
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
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .blueAccent,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            15))),
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    40),
                                                            width:
                                                                getProportionateScreenWidth(
                                                                    140),
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                "BUY",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
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
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    40),
                                                            width:
                                                                getProportionateScreenWidth(
                                                                    140),
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                "SELL",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Purchase Price",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  snapshot.data[index].purchase_price
                                      .toString(),
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Investment",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  snapshot.data[index].sch_amount.toString(),
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Present Value",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  snapshot.data[index].sch_amount.toString(),
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Present Value",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  snapshot.data[index].present_invest
                                      .round()
                                      .toString(),
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
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
  final String bse_scheme_code;
  final String fr_scheme_name;
  var purchase_price;
  var nav_price;
  final double sch_amount;
  final double all_units;
  final String scheme_type;
  final double present_invest;

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
      this.present_invest);
}
