import 'dart:io';
import 'package:pams_manager/models/login_model.dart';
import 'package:pams_manager/models/search_model.dart';
import 'package:pams_manager/models/site_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class OptionDbHelper {
  static Database? _optionDb;
  static OptionDbHelper? _optionDbHelper;

  String tbLogin = "tbLogin";
  String tbSearch = "tbSearch";
  String colUid = "UID";
  String colId = "ID";
  String colSaveId = "IS_SAVE_ID";
  String colDay = "DAY";
  String colLoc = "LOCATION";
  String colNotInspection = "IS_NOT_INSPECTION";
  String colCompleteInspection = "IS_COMP_INSPECTION";

  OptionDbHelper._createInstance();

  static final OptionDbHelper db = OptionDbHelper._createInstance();

  factory OptionDbHelper() {
    if (_optionDbHelper == null) {
      _optionDbHelper = OptionDbHelper._createInstance();
    }
    return _optionDbHelper!;
  }

  Future<Database> get database async {
    if (_optionDb == null) {
      _optionDb = await initializeDatabase();
    }
    return _optionDb!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/pamsm.db';
    var pamsDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return pamsDb;
  }

  void _createDb(Database db, int newVersion) async {
    // 로그인 정보
    await db.execute("CREATE TABLE $tbLogin ("
        "$colUid INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colId TEXT DEFAULT '', "
        "$colSaveId TEXT DEFAULT ''"
        ")");
    // 조회 옵션
    await db.execute("CREATE TABLE $tbSearch ("
        "$colUid INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colDay TEXT DEFAULT '', "
        "$colLoc TEXT DEFAULT '', "
        "$colNotInspection INTEGER DEFAULT 1, "
        "$colCompleteInspection INTEGER DEFAULT 1"
        ")");

    // 로그인 테이블의 기본 정보 등록
    String query = "INSERT INTO $tbLogin (";
    query += "$colId, $colSaveId";
    query += ") VALUES (";
    query += "'', 1";
    query += ")";
    await db.execute(query);
    // 조회 테이블의 기본 정보 등록
    query = "INSERT INTO $tbSearch (";
    query += "$colDay, $colLoc, $colNotInspection, $colCompleteInspection";
    query += ") VALUES (";
    query += "'', '', 1, 1";
    query += ")";
    await db.execute(query);
  }

  // 로그인 옵션 가져오기
  Future<LoginModel> getLoginOption() async {
    LoginModel option = LoginModel();
    try {
      final db = await database;
      String query = "SELECT $colUid, $colId, $colSaveId FROM $tbLogin";
      List<Map<String, dynamic>> maps = await db!.rawQuery(query);
      if (maps.length > 0) {
        option.uid = maps[0]["$colUid"];
        option.id = maps[0]["$colId"];
        option.isSaveId = maps[0]["$colSaveId"] == "1" ? true : false;
      }
    } catch (e) {}
    return option;
  }

  // 로그인 옵션 갱신하기
  Future<void> updateLoginOption(LoginModel option) async {
    var db = await database;
    try {
      String sql = "UPDATE $tbLogin SET ";
      sql += "$colId='" + option.id! + "', ";
      sql += "$colSaveId=" + (option.isSaveId == true ? 1 : 0).toString();
      //print(sql);
      db.execute(sql);
    } catch (e) {}
  }

  // 검색 옵션 가져오기
  Future<SearchModel> getSearchOption() async {
    SearchModel option = SearchModel();
    try {
      final db = await database;
      String query =
          "SELECT $colDay, $colLoc, $colNotInspection, $colCompleteInspection FROM $tbSearch";
      List<Map<String, dynamic>> maps = await db!.rawQuery(query);
      if (maps.length > 0) {
        option.day = maps[0]["$colDay"];
        option.location = maps[0]["$colLoc"];
        option.isNotInspection =
            maps[0]["$colNotInspection"] == 1 ? true : false;
        option.isCompInspection =
            maps[0]["$colCompleteInspection"] == 1 ? true : false;
      }
    } catch (e) {}
    return option;
  }

  // 검색 옵션 갱신하기
  Future<void> updateSearchOption(SearchModel option) async {
    var db = await database;
    try {
      String sql = "UPDATE $tbSearch SET ";
      sql += "$colDay='" + option.day! + "', ";
      sql += "$colLoc=" + (option.location == true ? 1 : 0).toString() + ", ";
      sql += "$colNotInspection=" +
          (option.isNotInspection == true ? 1 : 0).toString() +
          ", ";
      sql += "$colCompleteInspection=" +
          (option.isCompInspection == true ? 1 : 0).toString();
      db.execute(sql);
    } catch (e) {}
  }

  // 닫기
  close() async {
    var db = await this.database;
    var result = db.close();
    return result;
  }
}
