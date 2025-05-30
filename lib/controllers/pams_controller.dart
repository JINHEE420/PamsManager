import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pams_manager/controllers/db_controller.dart';
import 'package:pams_manager/models/dashboard_monthly_model.dart';
import 'package:pams_manager/models/equip_list.model.dart';
import 'package:pams_manager/models/inspection_model.dart';
import 'package:pams_manager/models/search_model.dart';
import 'package:pams_manager/models/site_model.dart';
import 'package:pams_manager/models/siteinfo_model.dart';
import 'package:pams_manager/models/user_model.dart';
import 'package:pams_manager/screens/camera_screen.dart';
import 'package:pams_manager/screens/dashboard_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../consts/colors.dart';
import '../models/login_model.dart';
import '../models/pile_model.dart';
import '../models/record_model.dart';
import '../screens/measure_screen.dart';
import '../screens/piles_screen.dart';
import '../screens/record_screen.dart';
import '../utils/api_endpoints.dart';
import '../utils/snack_bar_util.dart';
import 'package:intl/intl.dart';

class PamsController extends GetxController {
  DbController dbController = Get.put(DbController());

  UserModel user = UserModel();
  LoginModel login = LoginModel();
  SearchModel search = SearchModel();
  SiteModel site = SiteModel();
  EquipListModel equiplist = EquipListModel();
  InspectionModel inspection = InspectionModel();

  CameraDescription? camera;
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController checkingLengthController = TextEditingController();
  XFile? photoImage;
  Uint8List? uIntImage;
  String? base64Image;
  String? oImage;
  bool isSaveId = true;
  final int rowCnt = 100;
  int selectedPileCode = 0;
  bool isTakePicture = false;
  //int a = DateFormat(format).format(now2);
  final DateTime now = DateTime.now();
  final String yearformat = 'yyyy'; // 연도 포맷
  final String monthformat = 'MM'; // 월 포맷
  double checkingData = 0;
  bool isAllSelected =
      false; // false로 해야 선택한 날짜의 리스트를 불러와준다 값이 true면 전체 리스트를 불러온다.
  int equipCode = 0;
  bool dashResult = true; // dashboard_screen 페이지 future의 삼항연산자를 이용하기 위해 사용.
  bool equipButtonResult = true; //pile_screen 페이지 future의 삼항연산자를 이용하기 위해 사용.

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  fetchData() async {
    // 로그인 옵션
    login = await dbController.getLoginOption();
    isSaveId = login.isSaveId!;
    idController.text = login.id!;
    // 검색 옵션
    search = await dbController.getSearchOption();
    if (search.location! == "" || search.location! == "0") {
      search.location = "전체";
    }
  }

  // 검색 조건 텍스트 가져오기
  String getSearchCondition() {
    String msg = "";
    msg += "일자 : " + search.day!;
    msg += " | 위치 : " + search.location!;
    msg += " | 점검 : ";
    if (search.isNotInspection! && search.isCompInspection!)
      msg += "전체";
    else if (search.isNotInspection!) {
      msg += "미점검";
    } else if (search.isCompInspection!) {
      msg += "점검완료";
    }
    return msg;
  }

  // 로그인시 오늘 날짜로 업데이트 (DB)
  Future<void> updateSearchDayToToday() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await dbController.updateSearchDayToToday(today);
    search.day = today;
  }

  // 검색 조건 업데이트
  void updateSearchOption() {
    dbController.updateSearchOption(search);
  }

  // 점검 데이터 처리
  void updateInspectionProc(int count) {
    if (count == 1) {
      if (photoImage!.path == "") {
        base64Image = inspection.photo;
      } else {
        File file = File(photoImage!.path);
        base64Image = base64Encode(file.readAsBytesSync());
      }
      updateInspectionData();
    }
  }

  // 로그인 처리
  Future<void> loginProc() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.login);
      Map body = {'id': idController.text.trim(), 'pw': pwController.text};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] > 0 &&
                (json['authCode'] == 80 ||
                    json['authCode'] == 1 ||
                    json['authCode'] == 3) ||
            json['authCode'] == 20) {
          user.custCode = json['custCode'];
          user.code = json['code'];
          user.id = idController.text;
          user.name = json['name'];
          user.authCode = json['authCode'];
          if (user.authCode == 20) {
            dashResult = false;
          }
          site.code = json['siteCode'];

          login.isSaveId = isSaveId;
          if (isSaveId) {
            login.id = idController.text.trim();
          } else {
            login.id = "";
          }
          dbController.updateLoginOption(login);

          idController.clear();
          pwController.clear();

          await updateSearchDayToToday();

          //Get.offAll(PilesScreen());
          Get.offAll(DashboardScreen());
        } else {
          SnackBarUtil.show("사용자인증", "사용권한이 없거나, 사용자 정보가 없습니다");
        }
      }
    } catch (e) {}
  }

  // 장비선택 후 파일 결과 리스트 가져오기
  Future<List<PileModel>> getPileListIncludeEquip(int equipcode) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.pileEndPoints.pileListIncludeEquip);
      Map body = {
        'id': user.id,
        'siteCode': site.code,
        'equipCode': equipcode,
        'date': search.day,
        'location': search.location,
        'isChkNot': search.isNotInspection,
        'isChkComplete': search.isCompInspection,
        'pileNo': '',
        'prevPileCode': 0,
        'rowCnt': rowCnt
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final piles = jsonDecode(response.body) as List;

        return piles.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return PileModel(
              code: map['code'] as int,
              number: map['number'] as String,
              location: map['location'] as String,
              totalAmount: map['totalAmount'] as String,
              avgAmount: map['avgAmount'] as String,
              avgRebound: map['avgRebound'] as String,
              inspection: map['isInspection'] as bool,
              remainingLength: map['remainingLength'] as String,
              checkingLength: map['checkingLength'] as String);
        }).toList();
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      throw Exception("error pile list");
    }
  }

  // 파일 결과 리스트 가져오기 * 지금은 안씀!!!!!(getPileListRange)로 대체 됨.
  Future<List<PileModel>> getPileList() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.pileEndPoints.pileList);
      Map body = {
        'id': user.id,
        'siteCode': site.code,
        'date': search.day,
        'location': search.location,
        'isChkNot': search.isNotInspection,
        'isChkComplete': search.isCompInspection,
        'pileNo': '',
        'prevPileCode': 0,
        'rowCnt': rowCnt
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final piles = jsonDecode(response.body) as List;
        return piles.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return PileModel(
              code: map['code'] as int,
              number: map['number'] as String,
              location: map['location'] as String,
              totalAmount: map['totalAmount'] as String,
              avgAmount: map['avgAmount'] as String,
              avgRebound: map['avgRebound'] as String,
              inspection: map['isInspection'] as bool,
              remainingLength: map['remainingLength'] as String,
              checkingLength: map['checkingLength'] as String);
        }).toList();
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      throw Exception("error pile list");
    }
  }

  // 파일 전체 날짜 결과 리스트 가져오기
  Future<List<PileModel>> getPileListRange(bool isAll) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.pileEndPoints.pileListrange);
      Map body = {
        'id': user.id,
        'siteCode': site.code,
        'isAll': isAll,
        'beginDate': search.day,
        'endDate': search.day,
        'location': search.location,
        'isChkNot': search.isNotInspection,
        'isChkComplete': search.isCompInspection,
        'pileNo': '',
        'prevPileCode': 0,
        'rowCnt': rowCnt
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final piles = jsonDecode(response.body) as List;
        return piles.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return PileModel(
              code: map['code'] as int,
              number: map['number'] as String,
              location: map['location'] as String,
              totalAmount: map['totalAmount'] as String,
              avgAmount: map['avgAmount'] as String,
              avgRebound: map['avgRebound'] as String,
              inspection: map['isInspection'] as bool,
              remainingLength: map['remainingLength'] as String,
              checkingLength: map['checkingLength'] as String);
        }).toList();
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      throw Exception("error pile list");
    }
  }

  // 장비 리스트 출력
  Future<List<EquipListModel>> getEquipListInfoData() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.siteEndPoints.equipList);
      Map body = {'id': user.id.trim(), 'siteCode': site.code};

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> equipListJson = jsonDecode(response.body);

        return equipListJson
            .map((json) => EquipListModel.fromJson(json))
            .toList();
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print(e);
      throw Exception("error siteInfo data");
    }
  }

  // 대시보드 진행률 정보 가져오기 (Y만 가져옴)
  Future<DashBoardModel> getDashBoard(int year, int month) async {
    var headers = {'Content-Type': 'application/json'};
    int newYear;
    int newMonth;

    // 기본값 설정: year이 0이면 현재 연도, month가 0이면 현재 월로 설정
    newYear =
        (year == 0) ? int.parse(DateFormat(yearformat).format(now)) : year;
    newMonth =
        (month == 0) ? int.parse(DateFormat(monthformat).format(now)) : month;

    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.dashBoardPoints.dashBoard);

      // 요청할 바디 데이터
      Map<String, dynamic> body = {
        'id': user.id,
        'siteCode': site.code,
        'year': newYear,
        'month': newMonth
      };

      // API 호출
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      // 상태 코드 확인 후 데이터 파싱
      if (response.statusCode == 200) {
        // final info = jsonDecode(response.body);
        // print(info);
        // JSON 파싱 및 모델 반환
        return DashBoardModel.fromJson(json.decode(response.body));
      } else {
        // 서버 응답 상태가 200이 아닐 경우
        throw Exception(
            'Failed to load dashboard: Status Code ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류나 기타 예외 처리
      throw Exception('Error fetching dashboard: $e');
    }
  }

  // 대시보드 진행률 정보 가져오기 (Y 와 N 모두를 가져옴)
  Future<DashBoardModel> getTotalDashBoard(int year, int month) async {
    var headers = {'Content-Type': 'application/json'};
    int newYear;
    int newMonth;

    // 기본값 설정: year이 0이면 현재 연도, month가 0이면 현재 월로 설정
    newYear =
        (year == 0) ? int.parse(DateFormat(yearformat).format(now)) : year;
    newMonth =
        (month == 0) ? int.parse(DateFormat(monthformat).format(now)) : month;

    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.dashBoardPoints.totaldashBoard);

      // 요청할 바디 데이터
      Map<String, dynamic> body = {
        'id': user.id,
        'siteCode': site.code,
        'year': newYear,
        'month': newMonth
      };

      // API 호출
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      // 상태 코드 확인 후 데이터 파싱
      if (response.statusCode == 200) {
        // final info = jsonDecode(response.body);
        // print(info);
        // JSON 파싱 및 모델 반환
        return DashBoardModel.fromJson(json.decode(response.body));
      } else {
        // 서버 응답 상태가 200이 아닐 경우
        throw Exception(
            'Failed to load dashboard: Status Code ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류나 기타 예외 처리
      throw Exception('Error fetching dashboard: $e');
    }
  }

  // 말뚝 위치 가져오기
  Future<List<String>> getLocList() async {
    List<String> locList = <String>[];
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.pileEndPoints.pileLocList);
      Map body = {'id': user.id, 'siteCode': site.code};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> locs = jsonDecode(response.body);
        for (int i = 0; i < locs.length; i++) {
          locList.add(locs[i]['location']);
        }
      }
      locList.insert(0, "전체");
    } catch (e) {}
    return locList;
  }

  // 현장 리스트 가져오기
  Future<List<SiteModel>> getSiteList() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.siteEndPoints.siteList);
      Map body = {'id': user.id.trim(), 'custCode': user.custCode};

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final sites = jsonDecode(response.body) as List;
        return sites.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return SiteModel(
              code: map['code'] as int, name: map['name'] as String);
        }).toList();
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      throw Exception("error site list");
    }
  }

  // 현장 공정률, 전체계획, 시공, 잔여 데이트 가져오기 (Y만 가져옴.)
  Future<SiteInfoModel> getSiteInfoData() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.siteEndPoints.siteInfo);
      Map body = {'id': user.id.trim(), 'siteCode': site.code};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final siteinfo = jsonDecode(response.body);
        //print(siteinfo);
        return SiteInfoModel(
            pileCnt: siteinfo['pileCnt'],
            pileCompleteCnt: siteinfo['pileCompleteCnt']);
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print(e);
      throw Exception("error siteInfo data");
    }
  }

  // 현장 공정률, 전체계획, 시공, 잔여 데이트 가져오기 (Y 와 N을 다 가져옴.)
  Future<SiteInfoModel> getSiteTotalInfoData() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.siteEndPoints.siteTotalInfo);
      Map body = {'id': user.id.trim(), 'siteCode': site.code};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final siteinfo = jsonDecode(response.body);
        //print(siteinfo);
        return SiteInfoModel(
            pileCnt: siteinfo['pileCnt'],
            pileCompleteCnt: siteinfo['pileCompleteCnt']);
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print(e);
      throw Exception("error siteInfo data");
    }
  }

  // 파일 정보 가져오기
  Future<RecordModel> getRecordData() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.pileEndPoints.recordData);
      Map body = {'id': user.id.trim(), 'pileCode': selectedPileCode};

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final pile = jsonDecode(response.body);
        return RecordModel(
            constDay: pile['constDay'],
            equipName: pile['equipName'],
            number: pile['pileNo'],
            location: pile['pileLoc'],
            hammerW: pile['hammer'].toDouble(),
            depth: pile['pileDepth'].toDouble(),
            length: pile['pileLength'].toDouble(),
            fallH: pile['fallHeight'].toDouble(),
            totalAmount: pile['totalAmount'].toDouble(),
            avgAmount: pile['avgAmount'].toDouble(),
            avgRebound: pile['avgRebound'].toDouble(),
            efficiency: pile['efficiency'].toDouble(),
            logData: pile['logFile']);
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      throw Exception("error pile data");
    }
  }

  // 파일 점검 데이터 가져오기
  Future<InspectionModel> getInspectionData() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.inpectionEndPoints.inspection);
      Map body = {'id': user.id.trim(), 'pileCode': selectedPileCode};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final record = jsonDecode(response.body);
        inspection.code = record['code'].toInt();
        inspection.constDay = record['constDay'];
        inspection.number = record['pileNo'];
        inspection.location = record['location'];
        inspection.pileDepth = record['pileDepth'].toDouble();
        inspection.pileLength = record['pileLength'].toDouble();
        inspection.remainingLength = record['remainingLength'].toDouble();
        inspection.isInspection = record['isInspection'] == 1 ? true : false;
        inspection.regDt = record['regDt'];
        inspection.updateDt = record['updateDt'];

        if (!isTakePicture) {
          inspection.checkingLength = record['checkingLength'].toDouble();

          // 수정 시작점
          if (inspection.checkingLength == 0.00) {
            checkingLengthController.text =
                inspection.checkingLength.toStringAsFixed(-1);
          } else {
            checkingLengthController.text =
                inspection.checkingLength.toStringAsFixed(2);
          }
          //수정 끝점

          inspection.photo = record['photo'];

          if (inspection.photo != "") {
            uIntImage = base64Decode(inspection.photo);
            photoImage = XFile.fromData(uIntImage!);
          }
        } else {
          isTakePicture = false;
        }
        return inspection;
      } else {
        inspection.photo = "";
        return inspection;
      }
    } catch (e) {
      inspection.photo = "";
      return inspection;
    }
  }

  // 선택 현장 사용으로 등록
  Future<void> setUseSite() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.siteEndPoints.useSite);
      Map body = {'userCode': user.code, 'siteCode': site.code};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        print("change site");
      }
    } catch (e) {
      throw Exception("error pile data");
    }
  }

  // 점검 데이터 등록
  Future<void> updateInspectionData() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.inpectionEndPoints.saveInspection);
      Map body = {
        'id': user.id,
        'pileCode': selectedPileCode,
        'checkingLength':
            double.parse(checkingLengthController.text.toString()),
        'photoImage': base64Image
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        goHomeScreen();
      }
    } catch (e) {
      throw Exception("error pile data");
    }
  }

  // 파일 리스트 화면으로 이동
  void goHomeScreen() {
    photoImage = null;
    Get.offAll(PilesScreen());
  }

  // 기록지 화면으로 이동
  void goRecordScreen() {
    Get.offAll(RecordScreen());
  }

  // 점검 화면으로 이동
  void goInspectionScreen() {
    Get.offAll(MeasureScreen());
  }

  // 사진 촬영 화면으로 이동
  void goTakeImage() {
    print("Navigating to CameraScreen...");
    try {
      Get.to(() => CameraScreen(camera: camera!));
      print("Navigation successful.");
    } catch (e, stackTrace) {
      print('Navigation Error: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  void setCamera(CameraDescription cam) {
    camera = cam;
    update(); // GetX 상태 업데이트
  }

  // 앱 종료
  void exitApp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          title: Text(
            "PAMS",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                /*
                  Divider(
                      color: DIVIDER_COLOR
                  ),
                  SizedBox(height: 10.0,),
                   */
                ListBody(
                  children: [
                    Text(
                      "앱을 종료하겠습니까?",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                side: BorderSide(color: PRIMARY_COLOR, width: 0),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text(
                "예",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                side: BorderSide(color: PRIMARY_COLOR, width: 0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "아니오",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
