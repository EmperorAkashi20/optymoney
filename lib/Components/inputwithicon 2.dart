import 'package:flutter/material.dart';

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;

  InputWithIcon({
    Key? key,
    required this.icon,
    required this.hint,
    this.keyboardTypeGlobal,
    this.dataController,
    this.enabledOrNot,
    required this.obscureText,
    this.onSaved,
    this.validator,
    this.onChanged,
  });
  final TextInputType? keyboardTypeGlobal;
  final TextEditingController? dataController;
  final bool? enabledOrNot;
  final bool? obscureText;
  final Function? onSaved;
  final Function? validator;
  final Function? onChanged;

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBC7C7C7), width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )),
          Expanded(
            child: TextFormField(
              obscureText: widget.obscureText!,
              controller: widget.dataController,
              enabled: widget.enabledOrNot,
              onSaved: (newValue) => widget.onSaved,
              validator: (value) => widget.validator.toString(),
              onChanged: (value) => widget.onChanged,
              keyboardType: widget.keyboardTypeGlobal,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                border: InputBorder.none,
                hintText: widget.hint,
              ),
            ),
          )
        ],
      ),
    );
  }
}
