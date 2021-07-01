import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:optymoney/PostLogin/Tax/Components/filepicker.dart';
import 'package:optymoney/PostLogin/dashboard/dashboarddata.dart';
import 'package:optymoney/models.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

makeitrRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=itrRegistration&subaction=submit');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  Map<String, dynamic> body = {
    'itr_e': 'itr',
    'fname': 'Sai Krishna Porala',
    'mobile': '9606796516',
    'pan': 'AXFPP0304C',
    'dobofusr': '1998-02-12',
    'address':
        'No 38/b 3rd cross prakruthi nagar kogilu main road yelahanka bangalore KA',
    'father_name': 'P Krishna Murthy',
    'email': 'saikrishnaporala@gmail.com',
    'aadhaar': '543554326543',
    'description': '',
    'bank': 'ICICI',
    'acno': '004001568263',
    'ifsc': 'icic0000040',
    'c_acnt_c': '0',
    'c_acnt': '',
    'f_travel_c': '0',
    'f_travel_val': '',
    'e_bill_c': '0',
    'e_bill': '',
  };

  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );
  print(response.body);
}

_asyncFileUpload(String text, File file) async {
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse("<url>"));
  //add text fields
  request.fields["text_field"] = text;
  //create multipart using filepath, string or bytes
  var pic = await http.MultipartFile.fromPath("file_field", file.path);
  //add multipart to request
  request.files.add(pic);
  var response = await request.send();

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(responseString);
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

enum Selector { Yes, No }
enum Selector1 { Yes, No }
enum Selector2 { Yes, No }
enum ITRRadio { ITR, EAssessment }

class _BodyState extends State<Body> {
  DateTime selectedDate = DateTime.now();
  Selector? _selector = Selector.No;
  Selector? _selector1 = Selector.No;
  Selector? _selector2 = Selector.No;
  ITRRadio? _itrRadio = ITRRadio.ITR;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  // _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime.now(),
  //       helpText: "SELECT YOUR DATE OF BIRTH",
  //       confirmText: "CONFIRM",
  //       builder: (context, child) {
  //         return Theme(
  //           data: ThemeData.dark(),
  //           child: child!,
  //         );
  //       });
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("File Your ITR with Us"),
      ),
      drawer: AppDrawerMain(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                ListTile(
                  title: const Text('ITR Filing'),
                  leading: Radio<ITRRadio>(
                    value: ITRRadio.ITR,
                    groupValue: _itrRadio,
                    onChanged: (ITRRadio? value) {
                      setState(
                        () {
                          _itrRadio = value;
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('E-Assessment'),
                  leading: Radio<ITRRadio>(
                    value: ITRRadio.EAssessment,
                    groupValue: _itrRadio,
                    onChanged: (ITRRadio? value) {
                      setState(
                        () {
                          _itrRadio = value;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Card(
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Text(
                    "Financial Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TitleHeader(text: "Bank Name"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. ICICI Bank",
                  ),
                  TitleHeader(text: "Account Number"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.number,
                    hintText: "e.g. 1234 1234 1224 1234",
                  ),
                  TitleHeader(text: "IFSC Code"),
                  FormFieldGlobal(
                    keyboardTypeGlobal: TextInputType.text,
                    hintText: "e.g. IFSC1920",
                  ),
                  if (_itrRadio == ITRRadio.ITR)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleHeader(text: 'Upload Form 16/16A'),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                          child: Container(
                            width: windowWidth * 0.3,
                            height: windowHeight * 0.035,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Choose Files',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GlobalOutputField(
                          outputValue: 'Text',
                        ),
                        TitleHeader(text: 'Upload Other Attachments'),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                          child: Container(
                            width: windowWidth * 0.3,
                            height: windowHeight * 0.035,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Choose Files',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GlobalOutputField(
                          outputValue: 'Text',
                        ),
                      ],
                    ),
                  if (_itrRadio == ITRRadio.EAssessment)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleHeader(text: 'Upload Notice Copy'),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                          child: Container(
                            width: windowWidth * 0.3,
                            height: windowHeight * 0.035,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Choose Files',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GlobalOutputField(
                          outputValue: 'Text',
                        ),
                        TitleHeader(text: 'Last ITR Filed Copy'),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                          child: Container(
                            width: windowWidth * 0.3,
                            height: windowHeight * 0.035,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Choose Files',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GlobalOutputField(
                          outputValue: 'Text',
                        ),
                        TitleHeader(text: 'Any Other Attachments'),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                          child: Container(
                            width: windowWidth * 0.3,
                            height: windowHeight * 0.035,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Choose Files',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GlobalOutputField(
                          outputValue: 'Text',
                        ),
                      ],
                    ),
                  TitleHeader(text: "Does your total deposits exceed 1Cr?"),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('No'),
                        leading: Radio(
                          value: Selector.No,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                          value: Selector.Yes,
                          groupValue: _selector,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  TitleHeader(text: "Electricity charges exceed Rs. 1 Lakh?"),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('No'),
                        leading: Radio(
                          value: Selector.No,
                          groupValue: _selector1,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector1 = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                          value: Selector.Yes,
                          groupValue: _selector1,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector1 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  TitleHeader(
                      text:
                          "Foreign Travel expenses for self or other person in family exceeds Rs. 2 Lakhs?"),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('No'),
                        leading: Radio(
                          value: Selector.No,
                          groupValue: _selector2,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector2 = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio(
                          value: Selector.Yes,
                          groupValue: _selector2,
                          onChanged: (Selector? value) {
                            setState(() {
                              _selector2 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 15),
                  child: Container(
                    width: getProportionateScreenWidth(123),
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () async {
                        Navigator.pushNamed(context, FilePickerDemo.routeName);
                        //_selectFolder();
                        //await makeitrRequest();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }
}
