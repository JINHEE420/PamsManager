import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pams_manager/models/dashboard_monthly_model.dart';
import 'package:pams_manager/models/site_model.dart';
import 'package:pams_manager/models/siteinfo_model.dart';
import 'package:pams_manager/screens/piles_screen.dart';
import 'package:pams_manager/screens/record_data_sheet.dart';

import '../consts/colors.dart';
import '../controllers/pams_controller.dart';
import 'package:flutter/foundation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PamsController controller = Get.find();

  // 선택된 값들을 관리할 변수
  int? _selectedYear = DateTime.now().year;
  int? _month = DateTime.now().month;
  int? year = 0;
  int? day = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 현재 연도 가져오기
    int currentYear = DateTime.now().year;

    // 10년 전부터 현재까지의 연도를 리스트로 생성
    List<int> years = List.generate(11, (index) => currentYear - index);
    List<int> days = List.generate(12, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: Image.asset(
          'assets/img/logo_500_200_w.png',
          width: 120,
          height: 48,
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("파일 성과관리"),
                    onTap: () {
                      Get.offAll(PilesScreen());
                    },
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: BORDER_COLOR),
                ),
                child: FutureBuilder<List<SiteModel>>(
                  future: controller.getSiteList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: DropdownButton(
                            underline: SizedBox(),
                            isExpanded: true,
                            menuMaxHeight: 300,
                            value: controller.site.code ?? data[0].code,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: data.map((SiteModel site) {
                              return DropdownMenuItem(
                                value: site.code,
                                child: Text(
                                  site.name!,
                                  style: TextStyle(
                                      fontSize: 16, color: PRIMARY_TEXT_COLOR),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                controller.site.code = newValue!;

                                controller.setUseSite();
                              });
                            }),
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("◼ DASHBOARD",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<SiteInfoModel>(
                future: controller.dashResult
                    ? controller.getSiteInfoData()
                    : controller.getSiteTotalInfoData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          var persent =
                              int.parse(data.pileCompleteCnt.toString()) /
                                  int.parse(data.pileCnt.toString()) *
                                  100;
                          var restTask = int.parse(data.pileCnt.toString()) -
                              int.parse(data.pileCompleteCnt.toString());
                          return Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        "공정률",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text("전체계획",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                                  ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                          "${persent.toStringAsFixed(1)}%",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(data.pileCnt.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                )),
                              ]),
                              TableRow(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text("시공",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text("잔여",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                                  ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                          data.pileCompleteCnt.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text("$restTask",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                )),
                              ])
                            ],
                          );
                        });
                  } else {
                    return Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              //child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("◼ 진행률",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _selectedYear, // 선택된 값을 _selectedYear 설정
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedYear = newValue;
                              year = _selectedYear;
                            });
                          },
                          items: years.map<DropdownMenuItem<int>>((int year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _month, // 선택된 값을 _month 설정
                          onChanged: (int? newValue) {
                            setState(() {
                              _month = newValue;
                              day = _month;
                            });
                          },
                          items: days.map<DropdownMenuItem<int>>((int days) {
                            return DropdownMenuItem<int>(
                              value: days,
                              child: Text(days.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(23.0),
                        child: FutureBuilder(
                          future: controller.getDashBoard(year!, day!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              DashBoardModel data = snapshot.data!;
                              // 금일 시공 값 계산
                              int totalQty = 0;
                              for (var equip in data.states) {
                                if (equip.equipName == "합계") {
                                  for (var day in equip.days) {
                                    if (day.date ==
                                        DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now())) {
                                      totalQty = int.parse(day.qty);
                                    }
                                  }
                                }
                              }
                              return Text(
                                "금일시공:$totalQty",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FutureBuilder<DashBoardModel>(
                  future: controller.dashResult
                      ? controller.getDashBoard(year!, day!)
                      : controller.getTotalDashBoard(year!, day!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DashBoardModel data = snapshot.data!;

                      // 첫 번째 테이블의 열: (장비, 전체, 월)
                      List<String> columns1 = ["장비", "전체", "월"];
                      // 4개의 행을 위한 데이터 (항타1호기, 항타2호기, 합계, 공정률)
                      List<List<String>> firstTableData = [];

                      for (var equip in data.states) {
                        // 각 장비에 대해 날짜를 columns1에 추가
                        for (var day in equip.days) {
                          if (!columns1.contains(day.day)) {
                            columns1.add(day.day); // 중복되지 않으면 columns1에 날짜 추가
                          }
                        }

                        // 각 장비에 대한 데이터를 firstTableNewData에 추가
                        List<String> rowData = [
                          equip.equipName,
                          equip.totalQty.toString(),
                          equip.monthQty.toString(),
                        ];

                        // 날짜별 수량을 추가
                        for (var day in equip.days) {
                          rowData.add(day.qty); // 각 날짜의 수량을 추가
                        }

                        firstTableData.add(rowData); // 해당 장비의 데이터 추가
                      }

                      return Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          for (int i = 0; i < columns1.length; i++)
                            i: FixedColumnWidth(80),
                        },
                        children: [
                          // 헤더 (장비, 전체, 월)
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            children: [
                              ...columns1.map((column) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    column,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                          // 데이터 행
                          ...List.generate(firstTableData.length, (index) {
                            return TableRow(
                              children: [
                                ...firstTableData[index].map((cellData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      cellData,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
