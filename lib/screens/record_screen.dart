import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/screens/record_data_sheet.dart';
import '../consts/colors.dart';
import '../consts/dimens.dart';
import '../utils/exit_icon.dart';

class RecordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  PamsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              controller.goHomeScreen();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Image.asset(
            'assets/img/logo_500_200_w.png',
            width: 120,
            height: 48,
          ),
          centerTitle: true,
          actions: [
            ExitIcon().getExitIcon(context),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                // 페이지 타이틀
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  alignment: Alignment.center,
                  height: SUB_TITLE_HEIGHT,
                  decoration: BoxDecoration(color: SUB_TITLE_COLOR),
                  child: Text(
                    "파일 기초 관입량 측정 기록지",
                    style: TextStyle(
                      fontSize: SUB_TITLE_TEXT_SIZE,
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_TEXT_COLOR,
                    ),
                  ),
                ),
                // 타이틀 경계선
                Divider(color: DIVIDER_COLOR),
                FutureBuilder(
                  future: controller.getRecordData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return RecordDataSheet(record: snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
