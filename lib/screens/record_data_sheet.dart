import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/models/record_model.dart';
import '../consts/colors.dart';
import '../consts/dimens.dart';

class RecordDataSheet extends StatelessWidget {
  final RecordModel record;
  RecordDataSheet({required this.record, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PamsController controller = Get.find();

    final decodeBytes = base64.decode(record.logData!.replaceAll("\n", ""));
    String decode = utf8.decode(decodeBytes);
    List<String> recordData = decode.split("\n");
    List<FlSpot> chartData = [];
    double interval_x = 0.01;
    double x = 0;
    for (int i = 0; i < recordData.length; i++) {
      if (recordData[i] != "") {
        double y = double.parse(recordData[i]) * (record.efficiency! / 100.0);
        chartData.add(FlSpot(x += interval_x, y));
      }
    }

    return SafeArea(
      child: Column(
        children: [
          // 시공일자
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("시공일자", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(record.constDay!,
                          style: record_textStyle(scalable: true)),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("장비명", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text(record.equipName!, style: record_textStyle()),
                  ),
                ),
              ],
            ),
          ),
          // 파일번호, 파일위치
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("파일번호", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text(record.number!, style: record_textStyle()),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("파일위치", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text(record.location!, style: record_textStyle()),
                  ),
                ),
              ],
            ),
          ),
          // 해머중량, 낙하고
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("해머중량", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text("${record.hammerW!} ton",
                        style: record_textStyle()),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("낙하고", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text("${record.fallH!}m", style: record_textStyle()),
                  ),
                ),
              ],
            ),
          ),
          // 관입깊이, 파일길이
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("관입깊이", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text("${record.depth!}m", style: record_textStyle()),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text(
                    "파일길이",
                    style: record_textStyle(),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child:
                        Text("${record.length!}m", style: record_textStyle()),
                  ),
                ),
              ],
            ),
          ),
          // 경계라인
          Divider(color: DIVIDER_COLOR),
          // 전체관입량, 평균관입량
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text("전체관입량", style: record_textStyle()),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text("${record.totalAmount!.toStringAsFixed(1)}mm",
                        style: record_textStyle()),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: RECORD_TITLE_WIDTH,
                  child: Text(
                    "평균관입량",
                    style: TextStyle(
                      fontSize: RECORD_PAPER_TEXT_SIZE,
                      color: PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                    ),
                    child: Text("${record.avgAmount!.toStringAsFixed(1)}mm",
                        style: record_textStyle()),
                  ),
                ),
              ],
            ),
          ),
          // 평균리바운드
          // Container(
          //   padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          //   width: double.infinity,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         alignment: Alignment.center,
          //         width: RECORD_TITLE_WIDTH,
          //         child: Text("평균리바운드", style: record_textStyle()),
          //       ),
          //       Expanded(
          //         child: Container(
          //           padding: EdgeInsets.all(5),
          //           alignment: Alignment.centerLeft,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(5),
          //             border: Border.all(width: 1, color: SEARCH_BORDER_COLOR),
          //           ),
          //           child: Text("${record.avgRebound!.toStringAsFixed(1)}mm",
          //               style: record_textStyle()),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          // Chat
          SizedBox(
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Color(0xFFC0C0C0),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Color(0xFFC0C0C0),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border:
                          Border.all(color: const Color(0xFF808080), width: 1)),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: false,
                      color: const Color(0xFFFF0000),
                      barWidth: 1,
                      isStrokeCapRound: false,
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: false,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBorder: BorderSide(
                        width: 1,
                        color: Color(0xFFFFFFFF),
                      ),
                      tooltipPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle record_textStyle({bool scalable = false}) {
    return TextStyle(
      fontSize: RECORD_PAPER_TEXT_SIZE,
      color: PRIMARY_TEXT_COLOR,
      fontWeight: FontWeight.bold,
    );
  }
}
