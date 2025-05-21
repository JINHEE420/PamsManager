
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/colors.dart';

class SnackBarUtil {
  /**
   * SnackBar 표시
   */
  static void show(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: SNACK_BAR_BG_COLOR,
      colorText: SNACK_BAR_TEXT_COLOR,
      icon: Icon(Icons.error, color: Colors.red),
    );
  }
}