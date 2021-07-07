import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:optymoney/Components/outlinebtn.dart';
import 'package:optymoney/constants.dart';
import 'package:optymoney/models.dart';

makePostRequest(String filename, String url) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(http.MultipartFile('picture',
      File(filename).readAsBytes().asStream(), File(filename).lengthSync(),
      filename: filename.split("/").last));
  var res = await request.send();
}

makeItrRequest() async {
  var url = Uri.parse(
      'https://optymoney.com/ajax-request/ajax_response.php?action=itrRegistration&subaction=submit');
  //final headers = {'Content-Type': 'application/form-data'};
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
    'fileitr[]': Body.filesitr,
  };
  print(body);
  //String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  http.Response response = await http.post(
    url,
    //headers: headers,
    body: body,
    encoding: encoding,
  );

  print(response.body);
}

class Body extends StatefulWidget {
  static var filesitr;
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _itr = false;
  bool _ebill = false;
  bool _deposit = false;
  bool _foreignTravel = false;

  String? _fileNameform16;
  String? _fileNameother;
  String? _fileNamenotice;
  String? _fileNamelastitr;
  String? _fileNameeother;

  List<PlatformFile>? _pathsform16;
  List<PlatformFile>? _pathsother;
  List<PlatformFile>? _pathsnotice;
  List<PlatformFile>? _pathslastitr;
  List<PlatformFile>? _pathseother;

  String? _directoryPathform16;
  String? _directoryPathother;
  String? _directoryPathnotice;
  String? _directoryPathlastitr;
  String? _directoryPatheother;

  bool _loadingPathform16 = false;
  bool _loadingPathother = false;
  bool _loadingPathnotice = false;
  bool _loadingPathlastitr = false;
  bool _loadingPatheother = false;

  String? _extension;

  FileType _pickingType = FileType.any;
  bool _multiPick = true;
  TextEditingController _controller = TextEditingController();

  int _itemcountItr = 0;
  int _itemcountNoticeCopy = 0;
  int _itemcountLastItr = 0;
  int _itemcountOtherAttachments = 0;
  int _itemcount = 0;
  int _itemcount1 = 0;
  bool _showButtonStatus = false;

  var a = "null";

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPathform16 = true);
    try {
      _directoryPathform16 = null;
      _pathsform16 = (await FilePicker.platform.pickFiles(
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
      _loadingPathform16 = false;
      print(_pathsform16!.first.extension);
      _fileNameform16 = _pathsform16 != null
          ? _pathsform16!.map((e) => e.name).toString()
          : '...';
    });
  }

  void _openFileExplorerItrOther() async {
    setState(() => _loadingPathother = true);
    try {
      _directoryPathother = null;
      _pathsother = (await FilePicker.platform.pickFiles(
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
      _loadingPathother = false;
      print(_pathsother!.first.extension);
      _fileNameother = _pathsother != null
          ? _pathsother!.map((e) => e.name).toString()
          : '...';
    });
  }

  void _openFileExplorerEnotice() async {
    setState(() => _loadingPathnotice = true);
    try {
      _directoryPathnotice = null;
      _pathsnotice = (await FilePicker.platform.pickFiles(
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
      _loadingPathnotice = false;
      print(_pathsnotice!.first.extension);
      _fileNamenotice = _pathsnotice != null
          ? _pathsnotice!.map((e) => e.name).toString()
          : '...';
    });
  }

  void _openFileExplorerLastItr() async {
    setState(() => _loadingPathlastitr = true);
    try {
      _directoryPathlastitr = null;
      _pathslastitr = (await FilePicker.platform.pickFiles(
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
      _loadingPathlastitr = false;
      print(_pathslastitr!.first.extension);
      _fileNamelastitr = _pathslastitr != null
          ? _pathslastitr!.map((e) => e.name).toString()
          : '...';
    });
  }

  void _openFileExplorerEOther() async {
    setState(() => _loadingPatheother = true);
    try {
      _directoryPatheother = null;
      _pathseother = (await FilePicker.platform.pickFiles(
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
      _loadingPatheother = false;
      print(_pathseother!.first.extension);
      _fileNameeother = _pathseother != null
          ? _pathseother!.map((e) => e.name).toString()
          : '...';
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

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Center(
              child: Text(
                "Financial Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TitleHeader(text: 'Bank Name'),
            FormFieldGlobal(
              hintText: "Enter Your Bank Name",
            ),
            TitleHeader(text: 'Account Number'),
            FormFieldGlobal(
              hintText: "Enter your Account Number",
              keyboardTypeGlobal: TextInputType.number,
            ),
            TitleHeader(text: 'IFSC'),
            FormFieldGlobal(
              hintText: "Enter Your IFSC Code",
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ITR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 50.0),
                    child: Switch.adaptive(
                      value: _itr,
                      onChanged: (bool value) {
                        setState(() {
                          _itr = value;
                          print(value);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "E-Assessment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_itr == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              _openFileExplorer();
                            },
                            child: Text(
                              "Form 16/16A",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                          child: Builder(
                            builder: (BuildContext context) =>
                                _loadingPathform16
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: const CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : _directoryPathform16 != null
                                        ? ListTile(
                                            title: const Text('Directory path'),
                                            subtitle:
                                                Text(_directoryPathform16!),
                                          )
                                        : _pathsform16 != null
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30.0),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.20,
                                                child: Scrollbar(
                                                  child: ListView.separated(
                                                    itemCount: _pathsform16 !=
                                                                null &&
                                                            _pathsform16!
                                                                .isNotEmpty
                                                        ? _pathsform16!.length
                                                        : 1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      _itemcount =
                                                          _pathsform16 !=
                                                                      null &&
                                                                  _pathsform16!
                                                                      .isNotEmpty
                                                              ? _pathsform16!
                                                                  .length
                                                              : 1;
                                                      print(_itemcount);

                                                      final bool isMultiPath =
                                                          _pathsform16 !=
                                                                  null &&
                                                              _pathsform16!
                                                                  .isNotEmpty;
                                                      final String name = 'File $index: ' +
                                                          (isMultiPath
                                                              ? _pathsform16!
                                                                      .map((e) =>
                                                                          e.name)
                                                                      .toList()[
                                                                  index]
                                                              : _fileNameform16 ??
                                                                  '...');
                                                      Body.filesitr =
                                                          _pathsform16!
                                                              .map(
                                                                  (e) => e.path)
                                                              .toList()[index]
                                                              .toString();

                                                      return ListTile(
                                                        title: Text(
                                                          name,
                                                        ),
                                                        subtitle:
                                                            Text(Body.filesitr),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _openFileExplorerItrOther();
                            },
                            child: Text(
                              "Other Attachments",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                          child: Builder(
                            builder: (BuildContext context) => _loadingPathother
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: const CircularProgressIndicator(),
                                  )
                                : _directoryPathother != null
                                    ? ListTile(
                                        title: const Text('Directory path'),
                                        subtitle: Text(_directoryPathother!),
                                      )
                                    : _pathsother != null
                                        ? Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 30.0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            child: Scrollbar(
                                              child: ListView.separated(
                                                itemCount: _pathsother !=
                                                            null &&
                                                        _pathsother!.isNotEmpty
                                                    ? _pathsother!.length
                                                    : 1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  _itemcount1 =
                                                      _pathsother != null &&
                                                              _pathsother!
                                                                  .isNotEmpty
                                                          ? _pathsother!.length
                                                          : 1;
                                                  print(_itemcount1);
                                                  final bool isMultiPath =
                                                      _pathsother != null &&
                                                          _pathsother!
                                                              .isNotEmpty;
                                                  final String name =
                                                      'File $index: ' +
                                                          (isMultiPath
                                                              ? _pathsother!
                                                                      .map((e) =>
                                                                          e.name)
                                                                      .toList()[
                                                                  index]
                                                              : _fileNameother ??
                                                                  '...');
                                                  final path = _pathsother!
                                                      .map((e) => e.path)
                                                      .toList()[index]
                                                      .toString();

                                                  return ListTile(
                                                    title: Text(
                                                      name,
                                                    ),
                                                    subtitle: Text(path),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const Divider(),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_itr == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _openFileExplorerEnotice();
                            },
                            child: Text(
                              "Notice Copy",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                          child: Builder(
                            builder: (BuildContext context) =>
                                _loadingPathnotice
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : _directoryPathnotice != null
                                        ? ListTile(
                                            title: const Text('Directory path'),
                                            subtitle:
                                                Text(_directoryPathnotice!),
                                          )
                                        : _pathsnotice != null
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30.0),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.20,
                                                child: Scrollbar(
                                                  child: ListView.separated(
                                                    itemCount: _pathsnotice !=
                                                                null &&
                                                            _pathsnotice!
                                                                .isNotEmpty
                                                        ? _pathsnotice!.length
                                                        : 1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      _itemcount1 =
                                                          _pathsnotice !=
                                                                      null &&
                                                                  _pathsnotice!
                                                                      .isNotEmpty
                                                              ? _pathsnotice!
                                                                  .length
                                                              : 1;
                                                      print(_itemcount1);
                                                      final bool isMultiPath =
                                                          _pathsnotice !=
                                                                  null &&
                                                              _pathsnotice!
                                                                  .isNotEmpty;
                                                      final String name = 'File $index: ' +
                                                          (isMultiPath
                                                              ? _pathsnotice!
                                                                      .map((e) =>
                                                                          e.name)
                                                                      .toList()[
                                                                  index]
                                                              : _fileNamenotice ??
                                                                  '...');
                                                      final path = _pathsnotice!
                                                          .map((e) => e.path)
                                                          .toList()[index]
                                                          .toString();

                                                      return ListTile(
                                                        title: Text(
                                                          name,
                                                        ),
                                                        subtitle: Text(path),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _openFileExplorerLastItr();
                            },
                            child: Text(
                              "Last ITR Filed",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                          child: Builder(
                            builder: (BuildContext context) =>
                                _loadingPathlastitr
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : _directoryPathlastitr != null
                                        ? ListTile(
                                            title: const Text('Directory path'),
                                            subtitle:
                                                Text(_directoryPathlastitr!),
                                          )
                                        : _pathslastitr != null
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30.0),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.20,
                                                child: Scrollbar(
                                                  child: ListView.separated(
                                                    itemCount: _pathslastitr !=
                                                                null &&
                                                            _pathslastitr!
                                                                .isNotEmpty
                                                        ? _pathslastitr!.length
                                                        : 1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      _itemcount1 =
                                                          _pathslastitr !=
                                                                      null &&
                                                                  _pathslastitr!
                                                                      .isNotEmpty
                                                              ? _pathslastitr!
                                                                  .length
                                                              : 1;
                                                      print(_itemcount1);
                                                      final bool isMultiPath =
                                                          _pathslastitr !=
                                                                  null &&
                                                              _pathslastitr!
                                                                  .isNotEmpty;
                                                      final String name = 'File $index: ' +
                                                          (isMultiPath
                                                              ? _pathslastitr!
                                                                      .map((e) =>
                                                                          e.name)
                                                                      .toList()[
                                                                  index]
                                                              : _fileNamelastitr ??
                                                                  '...');
                                                      final path =
                                                          _pathslastitr!
                                                              .map(
                                                                  (e) => e.path)
                                                              .toList()[index]
                                                              .toString();

                                                      return ListTile(
                                                        title: Text(
                                                          name,
                                                        ),
                                                        subtitle: Text(path),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: windowWidth * 0.4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _openFileExplorerEOther();
                            },
                            child: Text(
                              "Other Attachments",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          elevation: 1,
                          child: Builder(
                            builder: (BuildContext context) =>
                                _loadingPatheother
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : _directoryPatheother != null
                                        ? ListTile(
                                            title: const Text('Directory path'),
                                            subtitle:
                                                Text(_directoryPatheother!),
                                          )
                                        : _pathseother != null
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30.0),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.20,
                                                child: Scrollbar(
                                                  child: ListView.separated(
                                                    itemCount: _pathseother !=
                                                                null &&
                                                            _pathseother!
                                                                .isNotEmpty
                                                        ? _pathseother!.length
                                                        : 1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      _itemcount =
                                                          _pathseother !=
                                                                      null &&
                                                                  _pathseother!
                                                                      .isNotEmpty
                                                              ? _pathseother!
                                                                  .length
                                                              : 1;
                                                      print(_itemcount);
                                                      final bool isMultiPath =
                                                          _pathseother !=
                                                                  null &&
                                                              _pathseother!
                                                                  .isNotEmpty;
                                                      final String name = 'File $index: ' +
                                                          (isMultiPath
                                                              ? _pathseother!
                                                                      .map((e) =>
                                                                          e.name)
                                                                      .toList()[
                                                                  index]
                                                              : _fileNameeother ??
                                                                  '...');
                                                      final path = _pathseother!
                                                          .map((e) => e.path)
                                                          .toList()[index]
                                                          .toString();

                                                      return ListTile(
                                                        title: Text(
                                                          name,
                                                        ),
                                                        subtitle: Text(path),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SwitchListTile.adaptive(
              title: Text("Does your total deposists exceed 1Cr?"),
              value: _deposit,
              onChanged: (bool value) {
                setState(() {
                  _deposit = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              title:
                  Text("Does your total electricity charges exceed Rs. 1Lakh?"),
              value: _ebill,
              onChanged: (bool value) {
                setState(() {
                  _ebill = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              title: Text(
                  "Foreign Travel expenses for self or other person in family exceeds Rs. 2Lakhs?"),
              value: _foreignTravel,
              onChanged: (bool value) {
                setState(() {
                  _foreignTravel = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () async {
                  await makeItrRequest();
                },
                child: OutlineBtn(btnText: "Proceed"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
