import 'package:flutter/material.dart';
import 'package:pams_manager/consts/colors.dart';

class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPw;

  InputTextFieldWidget(this.textEditingController, this.hintText, this.isPw);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: textEditingController,
        obscureText: isPw ? true : false,
        decoration: InputDecoration(
          hintText: hintText,
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
      ),
    );
  }
}
