import 'package:flutter/material.dart';
import 'package:pams_manager/consts/colors.dart';

class PamsTextField extends StatelessWidget {
  final String label;
  final bool isPw;
  final FormFieldSetter<String> onSaved;

  const PamsTextField({
    required this.label,
    required this.isPw,
    required this.onSaved,
    Key? key,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      obscureText: isPw ? true : false,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
            color: TEXT_HINT_COLOR
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(10.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: PRIMARY_COLOR,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: TEXT_FIELD_BORDER_COLOR,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

