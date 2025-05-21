import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pams_manager/consts/colors.dart';
import 'package:pams_manager/controllers/db_controller.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/models/pile_model.dart';
import 'package:pams_manager/models/site_model.dart';
import 'package:pams_manager/screens/dashboard_screen.dart';
import 'package:pams_manager/screens/search_bottom_sheet.dart';
import 'package:pams_manager/utils/exit_icon.dart';

import '../components/pile_card.dart';
import '../consts/dimens.dart';
import '../components/input_text_field.dart';

class PilesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PilesScreenState();
}

class _PilesScreenState extends State<PilesScreen> {
  PamsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getSiteList();
  }

  List<dynamic> pileLoclist = <String>[];

  String searchCondition = "";
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    if (controller.search.day == "") {
      controller.search.day = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(selectedDate.toString()))
          .toString();
    }
    if (searchCondition == "") {
      searchCondition = controller.getSearchCondition();
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/img/logo_500_200_w.png',
            width: 120,
            height: 48,
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  builder: (_) => SearchBottomSheet(),
                );
                if (result != null) {
                  setState(() {
                    //piles = controller.getPileList();
                    searchCondition = controller.getSearchCondition();
                    controller.goHomeScreen();
                  });
                }
              },
              icon: Icon(Icons.search)),
          actions: [
            ExitIcon().getExitIcon(context),
            PopupMenuButton(
              iconColor: Colors.white,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("대시보드"),
                      onTap: () {
                        Get.offAll(DashboardScreen());
                      },
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: SafeArea(
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
                  "파일 성과 관리",
                  style: TextStyle(
                    fontSize: SUB_TITLE_TEXT_SIZE,
                    fontWeight: FontWeight.bold,
                    color: PRIMARY_TEXT_COLOR,
                  ),
                ),
              ),
              // 타이틀 경계선
              Divider(color: DIVIDER_COLOR),
              Expanded(
                child: Container(
                  height: 300,
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Column(
                    children: [
                      // 현장 정보
                      Row(
                        children: [
                          Container(
                            width: 50,
                            child: Text(
                              "현장",
                              style: TextStyle(
                                fontSize: 18,
                                color: PRIMARY_TEXT_COLOR,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(width: 1, color: BORDER_COLOR),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder<List<SiteModel>>(
                                  future: controller.getSiteList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data!;
                                      return DropdownButton(
                                          underline: SizedBox(),
                                          isExpanded: true,
                                          menuMaxHeight: 300,
                                          value: controller.site.code ??
                                              data[0].code,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: data.map((SiteModel site) {
                                            return DropdownMenuItem(
                                              value: site.code,
                                              child: Text(
                                                site.name!,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: PRIMARY_TEXT_COLOR),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              controller.site.code = newValue!;
                                              controller.setUseSite();
                                              controller.goHomeScreen();
                                            });
                                          });
                                    } else {
                                      return Container(
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20.0,
                                                width: 20.0,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // 검색 내용
                      Container(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            searchCondition,
                            style: TextStyle(
                                fontSize: 18, color: PRIMARY_TEXT_COLOR),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1, color: SEARCH_BORDER_COLOR),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // 파일 리스트
                      Expanded(
                        child: FutureBuilder<List<PileModel>>(
                          future: controller.equipButtonResult
                              ? controller
                                  .getPileListRange(controller.isAllSelected)
                              : controller.getPileListIncludeEquip(
                                  controller.equipCode),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return RefreshIndicator(
                              onRefresh: () async {
                                setState(() {});
                              },
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: snapshot.data!
                                    .map((e) => PileCard(pile: e))
                                    .toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
