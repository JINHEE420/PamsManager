import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pams_manager/consts/colors.dart';
import 'package:pams_manager/consts/text_style.dart';

class PamsToast {
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: TOAST_BG_COLOR,
        textColor: Colors.white,
        fontSize: TEXT_SIZE
    );
  }
}