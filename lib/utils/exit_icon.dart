import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pams_manager/controllers/pams_controller.dart';

class ExitIcon {
  PamsController controller = Get.find();

  // 종료 아이콘 표시
  Widget getExitIcon(BuildContext context) {
    if (Platform.isIOS) {
      return Container();
    } else {
      return IconButton(
          onPressed: () {
            controller.exitApp(context);
          },
          icon: Icon(Icons.exit_to_app)
      );
    }
  }
}
