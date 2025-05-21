import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pams_manager/consts/colors.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/models/pile_model.dart';

import '../consts/dimens.dart';

class PileCard extends StatelessWidget {
  final PileModel pile;
  PamsController controller = Get.find();

  PileCard({required this.pile, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.selectedPileCode = pile.code!;
        controller.goRecordScreen();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: PILE_BORDER_COLOR),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      pile.number!,
                      style: TextStyle(
                        fontSize: PILE_CARD_NUMBER,
                        color: PRIMARY_TEXT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pile.location!,
                      style: TextStyle(
                        fontSize: PILE_CARD_LOCATION,
                        color: PRIMARY_TEXT_COLOR,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "평균관입량 : ${pile.avgAmount!} mm",
                          style: TextStyle(
                            fontSize: MEASURE_VALUE_TEXT,
                            color: PRIMARY_TEXT_COLOR,
                          ),
                        ),
                        /*
                        Text(
                          "평균리바운드량 : ${pile.avgRebound!} mm",
                          style: TextStyle(
                            fontSize: MEASURE_VALUE_TEXT,
                            color: PRIMARY_TEXT_COLOR,
                          ),
                        ),
                         */
                        Text(
                          "잔량 : ${pile.remainingLength!} m",
                          style: TextStyle(
                            fontSize: MEASURE_VALUE_TEXT,
                            color: PRIMARY_TEXT_COLOR,
                          ),
                        ),
                        Text(
                          "점검잔량 : ${pile.checkingLength!} m",
                          style: TextStyle(
                            fontSize: MEASURE_VALUE_TEXT,
                            color: PRIMARY_TEXT_COLOR,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: pile.inspection!
                              ? INSPECTION_COMP
                              : INSPECTION_NOT,
                          side: BorderSide(
                              color: pile.inspection!
                                  ? INSPECTION_COMP
                                  : INSPECTION_NOT,
                              width: 0),
                        ),
                        onPressed: () {
                          controller.selectedPileCode = pile.code!;
                          controller.goInspectionScreen();
                        },
                        child: Text(
                          pile.inspection! ? "점검완료" : "미점검",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
