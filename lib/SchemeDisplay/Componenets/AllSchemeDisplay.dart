import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class AllSchemeDisplay extends StatefulWidget {
  static var categoryId;
  @override
  _AllSchemeDisplayState createState() => _AllSchemeDisplayState();
}

class _AllSchemeDisplayState extends State<AllSchemeDisplay> {
  var _options = [
    'EQUITY',
    'ELSS',
    'HYBRID',
    'DEBT',
    'FOF',
  ];
  String _currentItemSelected = 'EQUITY';

  @override
  void initState() {
    super.initState();
    AllSchemeDisplay.categoryId = 32;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: Container(
            width: double.infinity,
            height: getProportionateScreenHeight(120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kPrimaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey.shade200,
                  isExpanded: true,
                  elevation: 0,
                  items: _options.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dropDownStringItem,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Divider(
                            thickness: 0.4,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValueSelected) {
                    _dropDownItemSelected(newValueSelected);
                  },
                  value: _currentItemSelected,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(),
    );
  }

  void _dropDownItemSelected(String? newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected.toString();
    });
  }
}
