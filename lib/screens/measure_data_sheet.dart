import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/models/inspection_model.dart';
import 'package:pams_manager/screens/measure_screen.dart';
import '../consts/colors.dart';
import '../consts/dimens.dart';

class MeasureDataSheet extends StatefulWidget {
  final InspectionModel record;
  MeasureDataSheet({required this.record, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeasureDataSheet();
}

class _MeasureDataSheet extends State<MeasureDataSheet> {
  PamsController controller = Get.find();
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InspectionModel record = widget.record;

    final double checkingInput =
        double.tryParse(controller.checkingLengthController.text) ?? 0.0;
    double measureData = record.pileLength - checkingInput;

    return Column(
      children: [
        // 작업 결과 및 점검 입력
        Container(
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
                      child: Text(
                        "시공일자",
                        style: TextStyle(
                          fontSize: RECORD_PAPER_TEXT_SIZE,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          record.constDay!,
                          style: TextStyle(
                              fontSize: RECORD_PAPER_TEXT_SIZE,
                              color: PRIMARY_TEXT_COLOR),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 파일번호, 파일번호
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
                      child: Text(
                        "파일번호",
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
                        child: Text(
                          record.number!,
                          style: TextStyle(
                            fontSize: RECORD_PAPER_TEXT_SIZE,
                            color: PRIMARY_TEXT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: RECORD_TITLE_WIDTH,
                      child: Text(
                        "파일위치",
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
                        child: Text(
                          record.location!,
                          style: TextStyle(
                            fontSize: RECORD_PAPER_TEXT_SIZE,
                            color: PRIMARY_TEXT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 파일깊이, 파일길이
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
                      child: Text(
                        "관입깊이",
                        style: TextStyle(
                          fontSize: RECORD_PAPER_TEXT_SIZE,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${record.pileDepth!}m",
                          style: TextStyle(
                              fontSize: RECORD_PAPER_TEXT_SIZE,
                              color: PRIMARY_TEXT_COLOR),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: RECORD_TITLE_WIDTH,
                      child: Text(
                        "파일길이",
                        style: TextStyle(
                          fontSize: RECORD_PAPER_TEXT_SIZE,
                          color: PRIMARY_TEXT_COLOR,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${record.pileLength!}m",
                          style: TextStyle(
                              fontSize: RECORD_PAPER_TEXT_SIZE,
                              color: PRIMARY_TEXT_COLOR),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 경계라인
              Divider(color: DIVIDER_COLOR),
              // 잔량
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
                      child: Text(
                        "잔량",
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
                        child: Text(
                          "${record.remainingLength!}m",
                          style: TextStyle(
                            fontSize: RECORD_PAPER_TEXT_SIZE,
                            color: PRIMARY_TEXT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 점검(잔량)
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
                      child: Text(
                        "측정잔량(m)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: RECORD_PAPER_TEXT_SIZE,
                          color: PRIMARY_TEXT_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: controller.checkingLengthController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: "측정치수",
                            hintStyle: TextStyle(color: TEXT_HINT_COLOR),
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
                                color: PRIMARY_COLOR,
                                width: 1.0,
                              ),
                            ),
                          ),
                          onChanged: (text) {
                            setState(() {
                              controller.checkingData =
                                  double.tryParse(text) ?? 0.0;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: RECORD_TITLE_WIDTH,
                      child: Text(
                        "측정관입\n깊이(m)",
                        textAlign: TextAlign.center,
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
                        child: Text(
                          "${measureData.toStringAsFixed(1)}m",
                          style: TextStyle(
                              fontSize: RECORD_PAPER_TEXT_SIZE,
                              color: PRIMARY_TEXT_COLOR),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: SEARCH_BORDER_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 사진
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: const Color(0xFF808080),
                  width: 3,
                ),
              ),
              child: renderImage(),
            ),
          ),
        ),
        // 기능 버튼
        Container(
          height: INSPECTION_HEIGHT,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 촬영
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  elevation: 5.0,
                  padding: EdgeInsets.all(20.0),
                ),
                onPressed: () {
                  controller.goTakeImage();
                },
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
              // 갤러리
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  elevation: 5.0,
                  padding: EdgeInsets.all(20.0),
                ),
                onPressed: () {
                  onPickImage();
                },
                icon: Icon(
                  Icons.photo_album_outlined,
                  color: Colors.white,
                ),
              ),
              // 등록
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  elevation: 5.0,
                  padding: EdgeInsets.all(20.0),
                ),
                onPressed: () {
                  final text = controller.checkingLengthController.text.trim();

                  // 측정값이 비어 있거나 0일 경우 제출 막기
                  if (text.isEmpty || controller.checkingData == 0.0) {
                    dialog(context);
                    return;
                  }

                  count++;
                  controller.updateInspectionProc(count);

                  // 제출 후 입력 초기화
                  controller.checkingLengthController.clear();
                  controller.checkingData = 0.0;

                  setState(() {}); // UI 갱신 (예: 측정관입깊이 영역)
                },
                icon: Icon(
                  Icons.upload,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 사진 표시
  Widget renderImage() {
    if (controller.photoImage != null) {
      return InteractiveViewer(child: renderPhotoImage());
    } else {
      return Center(
        child: Icon(Icons.image),
      );
    }
  }

  // 이미지 표시
  Widget renderPhotoImage() {
    if (controller.photoImage!.path != "") {
      return Image.file(
        File(controller.photoImage!.path),
        fit: BoxFit.cover,
      );
    } else {
      return Image.memory(
        controller.uIntImage!,
        fit: BoxFit.cover,
      );
    }
  }

  // 사진 선택
  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        controller.photoImage = image;
      });
    }
  }
}

// 측정잔량에 값이없을때(0.0) 띄워주는 alert 창
void dialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('확인'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('측정잔량을 입력해 주세요.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
