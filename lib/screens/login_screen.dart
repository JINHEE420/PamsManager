import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pams_manager/consts/colors.dart';
import 'package:pams_manager/controllers/pams_controller.dart';
import 'package:pams_manager/screens/dashboard_screen.dart';
import 'package:pams_manager/screens/piles_screen.dart';
import 'package:pams_manager/utils/snack_bar_util.dart';
import 'package:pams_manager/components/input_text_field.dart';
import '../consts/dimens.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PamsController controller = Get.find();
  bool _isSaveId = true;
  var isLogin = false.obs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: false,
          child: Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/logo_500_200_b.png',
                    width: 300,
                    height: 120,
                  ),
                  SizedBox(height: 16.0),
                  loginWidget(),
                  SizedBox(height: 16.0),
                  Text("YOUNGSHINE"),
                ],
              ),
            ),
          ),
        ),
      ),
      canPop: false,
    );
  }

  Widget loginWidget() {
    return Column(
      children: [
        SizedBox(
          width: LOGIN_INPUT_WIDTH,
          child: InputTextFieldWidget(controller.idController, "아이디", false),
        ),
        SizedBox(height: 5.0),
        SizedBox(
          width: LOGIN_INPUT_WIDTH,
          child: InputTextFieldWidget(controller.pwController, "비밀번호", true),
        ),
        SizedBox(height: 5.0),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: controller.isSaveId,
                activeColor: PRIMARY_COLOR,
                onChanged: (value) {
                  setState(() {
                    _isSaveId = value!;
                    controller.isSaveId = value!;
                  });
                },
              ),
              Text(
                "아이디 저장",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: LOGIN_BTN_WIDTH,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              side: BorderSide(color: PRIMARY_COLOR, width: 0),
            ),
            onPressed: () {
              if (controller.idController.text == "") {
                SnackBarUtil.show("사용자인증", "아이디를 입력해주세요");
              } else if (controller.pwController.text == "") {
                SnackBarUtil.show("사용자인증", "비밀번호를 입력해주세요");
              } else {
                controller.loginProc();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => DashboardScreen()));
              }
            },
            child: Text(
              "로그인",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
