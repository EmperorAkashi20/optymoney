import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';

class Body extends StatefulWidget {
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
    List<Scheme> schemes = [];
    for (var sch in jsonData) {
      Scheme scheme = Scheme(sch['isin'], sch['folio'], sch['bse_scheme_code'],
          sch['fr_scheme_name'], sch['purchase_price']);
      schemes.add(scheme);
    }
    return schemes;
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
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(snapshot.data[index].isin),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(snapshot.data[index].folio),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child:
                                    Text(snapshot.data[index].fr_scheme_name),
                              ),
                              Expanded(
                                flex: 1,
                                child:
                                    Text(snapshot.data[index].purchase_price),
                              ),
                            ],
                          ),
                        ],
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
  final String purchase_price;

  Scheme(this.isin, this.folio, this.bse_scheme_code, this.fr_scheme_name,
      this.purchase_price);
}
