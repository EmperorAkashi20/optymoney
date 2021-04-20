import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:optymoney/TransactionHistory/Components/Body.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Transact>> _getTransactions() async {
    var url = Uri.parse('https://optymoney.com/__lib.ajax/mutual_fund.php');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Map<String, dynamic> body = {
      'uid': "SignForm.userId",
      'pan': "SignForm.pan",
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
    List<Transact> schemes = [];
    for (var txn in jsonData) {
      Transact transact = Transact(
        txn['purchase_price'],
        txn['unit'],
        txn['purchase_date'],
        txn['tran_type'],
        txn[''],
        txn[''],
        //sch['all_units'],
        txn['scheme_type'],
      );
      schemes.add(transact);
    }
    return schemes;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Transact {
  final String purchase_price;
  final String unit;
  final String purchase_date;
  final String tran_type;
  final String trnx_id;
  final String amount;
  final String folio;

  Transact(
    this.purchase_price,
    this.unit,
    this.purchase_date,
    this.tran_type,
    this.trnx_id,
    this.amount,
    this.folio,
  );
}
