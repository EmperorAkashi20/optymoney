import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/UserInfo/UserInfoStartScreen.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

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
  print(Body.userId);
  Body.emailId = parsedJson['login_id'].toString();
  print(Body.emailId);
  Body.custId = parsedJson['fr_customer_id'].toString();
  print(Body.custId);
  Body.custName = parsedJson['cust_name'].toString();
  print(Body.custName);
  Body.custPan = parsedJson['pan_number'].toString();
  print(Body.custPan);
  Body.custLetter = Body.custName[0].toUpperCase();
  print(Body.custLetter);
  SignForm.email1 = Body.emailId;
  SignForm.name = Body.custName;
  SignForm.letter = Body.custLetter;
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
    var len = jsonData.length;
    print("Length");
    print(len);
    List<Scheme> schemes = [];
    for (var sch in jsonData) {
      //  Scheme(this.isin, this.folio, this.bse_scheme_code, this.fr_scheme_name,
      // this.purchase_price, this.scheme_type, this.amount, this.all_units);
      Scheme scheme = Scheme(
          sch['isin'],
          sch['folio'],
          sch['bse_scheme_code'],
          sch['fr_scheme_name'],
          sch['purchase_price'],
          sch['scheme_type'],
          sch['amount'].toDouble(),
          sch['all_units'].toDouble());
      print(sch['amount']);
      //print(scheme.sch_amount);
      if (sch['all_units'].toDouble() == 0 || sch['all_units'].toDouble() < 0) {
        // sch++;
      } else {
        schemes.add(scheme);
      }
    }
    return schemes;
  }

  @override
  void initState() {
    super.initState();
    makeUserRequest();
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
                      left: 15.0,
                      right: 15,
                      top: 10,
                    ),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data[index].fr_scheme_name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child:
                                        Text(snapshot.data[index].scheme_type)),
                                Expanded(
                                    child: Text(snapshot.data[index].all_units
                                        .toString())),
                                Expanded(
                                  child: Text(snapshot.data[index].sch_amount
                                      .toString()),
                                ),
                                Expanded(
                                  child: Text(snapshot
                                      .data[index].purchase_price
                                      .toString()),
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

class Scheme {
  final String isin;
  final String folio;
  final String bse_scheme_code;
  final String fr_scheme_name;
  var purchase_price;
  final double sch_amount;
  final double all_units;
  final String scheme_type;

  Scheme(this.isin, this.folio, this.bse_scheme_code, this.fr_scheme_name,
      this.purchase_price, this.scheme_type, this.sch_amount, this.all_units);
}
