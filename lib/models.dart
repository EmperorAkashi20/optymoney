import 'package:flutter/material.dart';
import 'size_config.dart';
import 'constants.dart';

// ----------------------------------------------------------------------------------Global----------------------------------------------------------------------------------------------------------------------------------

class FormFieldGlobal extends StatelessWidget {
  const FormFieldGlobal({
    Key? key,
    this.keyboardTypeGlobal,
    this.hintText,
    this.dataController,
    this.enabledOrNot,
  }) : super(key: key);

  final TextInputType? keyboardTypeGlobal;
  final String? hintText;
  final TextEditingController? dataController;
  final bool? enabledOrNot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Container(
        height: getProportionateScreenHeight(50),
        child: TextFormField(
          enabled: enabledOrNot,
          controller: dataController,
          keyboardType: keyboardTypeGlobal,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.1),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
                fontWeight: FontWeight.w100),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormFieldGlobalForPopUp extends StatelessWidget {
  const FormFieldGlobalForPopUp({
    Key? key,
    this.keyboardTypeGlobal,
    this.hintText,
    this.dataController,
    this.enabledOrNot,
  }) : super(key: key);

  final TextInputType? keyboardTypeGlobal;
  final String? hintText;
  final TextEditingController? dataController;
  final bool? enabledOrNot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(50),
      child: TextFormField(
        enabled: enabledOrNot,
        controller: dataController,
        keyboardType: keyboardTypeGlobal,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w100),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}

class FormFieldDisplayProfile extends StatelessWidget {
  const FormFieldDisplayProfile({
    Key? key,
    this.keyboardTypeGlobal,
    this.hintText,
    this.dataController,
    this.enabledOrNot,
    this.stringColor,
    this.change,
  }) : super(key: key);

  final TextInputType? keyboardTypeGlobal;
  final String? hintText;
  final TextEditingController? dataController;
  final bool? enabledOrNot;
  final Color? stringColor;
  final String? change;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Container(
        height: getProportionateScreenHeight(50),
        child: TextFormField(
          onChanged: (value) => change,
          enabled: enabledOrNot,
          controller: dataController,
          keyboardType: keyboardTypeGlobal,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.1),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 15.0,
                color: stringColor,
                fontWeight: FontWeight.w100),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleHeader extends StatelessWidget {
  const TitleHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class TitleHeaderForPopUp extends StatelessWidget {
  const TitleHeaderForPopUp({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class OutputTextForPopUp extends StatelessWidget {
  const OutputTextForPopUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "OUTPUT",
          style: TextStyle(
            fontSize: 19,
            color: kPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class GlobalOutputField extends StatelessWidget {
  const GlobalOutputField({
    Key? key,
    this.outputValue,
  }) : super(key: key);

  final String? outputValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: Container(
        height: getProportionateScreenHeight(50),
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(
              width: 1.1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                outputValue!,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuggestionBox1 extends StatelessWidget {
  const SuggestionBox1({
    Key? key,
    this.suggestion,
  }) : super(key: key);

  final String? suggestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
      child: Container(
        height: getProportionateScreenHeight(100),
        width: double.infinity,
        child: Container(
          decoration: ShapeDecoration(
            color: (Colors.cyanAccent).withOpacity(0.3),
            shape: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: "Suggestion: ",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: suggestion,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuggestionBox2 extends StatelessWidget {
  const SuggestionBox2({
    Key? key,
    this.suggestion,
    this.suggestion1,
  }) : super(key: key);

  final String? suggestion;
  final String? suggestion1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
      child: Container(
        height: getProportionateScreenHeight(100),
        width: double.infinity,
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.yellow.withOpacity(0.3),
            shape: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: suggestion,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: suggestion1,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleHeaderWithRichText extends StatelessWidget {
  const TitleHeaderWithRichText({
    Key? key,
    required this.text,
    required this.richText,
  }) : super(key: key);

  final String text;
  final String richText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: text,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
              ),
              TextSpan(
                text: richText,
                style: TextStyle(fontSize: 11.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------------Global----------------------------------------------------------------------------------------------------------------------------------
