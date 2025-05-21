import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../consts/colors.dart';
import '../consts/dimens.dart';
import '../utils/exit_icon.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  PamsController controller = Get.find();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 카메라 권한 요청 함수
  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            controller.goInspectionScreen();
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
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // Future가 완료되면, 즉 카메라 초기화가 끝나면 카메라 미리보기를 보여줍니다.
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller); // 카메라 미리보기 위젯
          } else {
            // 아직 로딩 중이라면 로딩 인디케이터를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          elevation: 10.0,
        ),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final photo = await _controller.takePicture();
            if (!mounted) return;

            controller.photoImage = photo;
            controller.isTakePicture = true;
            controller.goInspectionScreen();
          } catch (e) {
            print("Camera Error: $e");
          }
        },
        icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
        label: Text(
          "촬영",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
