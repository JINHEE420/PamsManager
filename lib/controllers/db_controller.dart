import 'package:get/get.dart';
import 'package:pams_manager/models/login_model.dart';
import 'package:pams_manager/models/pams_option_model.dart';
import 'package:pams_manager/models/search_model.dart';
import 'package:pams_manager/models/site_model.dart';
import 'package:pams_manager/utils/db_helper.dart';

class DbController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    OptionDbHelper.db.close();
    super.onClose();
  }

  // 로그인 옵션 가져오기
  Future<LoginModel> getLoginOption() async {
    return await OptionDbHelper.db.getLoginOption();
  }

  //로그인 옵션 수정하기
  void updateLoginOption(LoginModel option) async {
    await OptionDbHelper.db.updateLoginOption(option);
  }

  // 검색 옵션 가져오기
  Future<SearchModel> getSearchOption() async {
    return await OptionDbHelper.db.getSearchOption();
  }

  // 검색 옵션 수정하기
  void updateSearchOption(SearchModel option) async {
    await OptionDbHelper.db.updateSearchOption(option);
  }
}
