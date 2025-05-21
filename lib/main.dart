import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/screens/login_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable(); // 화면 꺼짐 방지

  // PamsController 등록
  PamsController controller = Get.put(PamsController());

  // 카메라 초기화 (안전 처리)
  try {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller.setCamera(cameras.first);
    } else {
      print("사용 가능한 카메라가 없습니다.");
    }
  } catch (e) {
    print("⚠️ 카메라 초기화 오류: $e");
  }

  runApp(
    GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}
