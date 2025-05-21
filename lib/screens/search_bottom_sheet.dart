import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/models/equip_list.model.dart';
import '../consts/colors.dart';
import '../components/input_text_field.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  EquipListModel? selectedEquip;

  @override
  void initState() {
    super.initState();
    if (controller.search.day == '전체') {
      String nowTime;
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      nowTime = formatter.format(now);
      controller.search.day = nowTime;
    }
  }

  PamsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
                border: Border.all(width: 1, color: BOTTOM_SHEET_BORDER_COLOR)),
            child: Column(
              children: [
                // 일자
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        "일자",
                        style: TextStyle(
                          fontSize: 18,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          final seletedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(controller.search.day!),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(3000),
                          );
                          setState(() {
                            controller.search.day = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(seletedDate.toString()))
                                .toString();
                          });
                        },
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: BORDER_COLOR),
                          ),
                          child: Text(
                            controller.search.day!,
                            style: TextStyle(
                              fontSize: 18,
                              color: PRIMARY_TEXT_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                // 전체일자
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        "전체",
                        style: TextStyle(
                          fontSize: 18,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: buttonStyle(),
                      onPressed: () {
                        controller.isAllSelected = true; // true = 전체날짜를 조회.
                        controller.getPileListRange(controller.isAllSelected);
                        controller.search.day = '전체';
                        Navigator.pop(context, "refresh");
                      },
                      child: Text("조회"),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        "장비",
                        style: TextStyle(
                          fontSize: 18,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: BORDER_COLOR),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<List<EquipListModel>>(
                            future: controller.getEquipListInfoData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!;
                                return DropdownButton<EquipListModel>(
                                  value: selectedEquip,
                                  hint: Text("장비를 선택하세요"),
                                  items: data.map((equip) {
                                    return DropdownMenuItem<EquipListModel>(
                                      value: equip,
                                      child: Text(equip.name!),
                                    );
                                  }).toList(),
                                  onChanged: (EquipListModel? newValue) {
                                    setState(() {
                                      selectedEquip = newValue;
                                      controller.equipCode =
                                          selectedEquip!.code!;
                                    });
                                  },
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      style: buttonStyle(),
                      onPressed: () {
                        controller
                            .getPileListIncludeEquip(controller.equipCode);
                        controller.equipButtonResult = false;

                        Navigator.pop(context, "refresh");
                      },
                      child: Text("조회"),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                // 파일위치
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        "파일위치",
                        style: TextStyle(
                          fontSize: 18,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: BORDER_COLOR),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<List<String>>(
                            future: controller.getLocList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!;
                                return DropdownButton(
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    menuMaxHeight: 300,
                                    value:
                                        controller.search.location ?? data[0],
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: data.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: PRIMARY_TEXT_COLOR),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        controller.search.location = newValue;
                                      });
                                    });
                              } else {
                                return const CircularProgressIndicator();
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
                // 검수여부
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        "검수상태",
                        style: TextStyle(
                          fontSize: 18,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: controller.search.isNotInspection,
                            activeColor: PRIMARY_COLOR,
                            onChanged: (value) {
                              setState(() {
                                controller.search.isNotInspection = value!;
                              });
                            },
                          ),
                          Text(
                            "미점검",
                            style: TextStyle(
                                fontSize: 18, color: PRIMARY_TEXT_COLOR),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Checkbox(
                            value: controller.search.isCompInspection,
                            activeColor: PRIMARY_COLOR,
                            onChanged: (value) {
                              setState(() {
                                controller.search.isCompInspection = value!;
                              });
                            },
                          ),
                          Text(
                            "점검완료",
                            style: TextStyle(
                                fontSize: 18, color: PRIMARY_TEXT_COLOR),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      side: BorderSide(color: PRIMARY_COLOR, width: 0),
                    ),
                    onPressed: () {
                      controller.isAllSelected =
                          false; // false = 선택한 날짜의 리스트만 조회.
                      controller.updateSearchOption();
                      Navigator.pop(context, "refresh");
                    },
                    child: Text(
                      "검색",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
