class ApiEndPoints {
  static final String baseUrl = "http://pams.smcapi.net/api/";
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
  static _SiteEndPoints siteEndPoints = _SiteEndPoints();
  static _PileEndPoints pileEndPoints = _PileEndPoints();
  static _DataEndPoints dataEndPoints = _DataEndPoints();
  static _InspectionEndPoints inpectionEndPoints = _InspectionEndPoints();
  static _DashBoardPoints dashBoardPoints = _DashBoardPoints();
}

class _AuthEndPoints {
  final String login = "user/login";
  final String logout = "user/logout";
}

class _SiteEndPoints {
  final String siteList = "manager/sitelist";
  final String useSite = "site/siteofuse";
  final String siteInfo = "site/info";
  final String siteTotalInfo = "site/infototal";
  final String equipList = 'manager/equiplist';
}

class _PileEndPoints {
  final String pileList = "manager/pilelist";
  final String pileListrange = "manager/pilelistforrange";
  final String pileLocList = "manager/pilelocationlist";
  final String recordData = "result/recordpaper";
  final String pileListIncludeEquip = 'manager/PileListIncludeEquip';
}

class _DataEndPoints {
  final String changeSite = "user/changesite";
}

class _InspectionEndPoints {
  final String inspection = "manager/inspectiondata";
  final String saveInspection = "manager/saveinspection";
}

class _DashBoardPoints {
  final String dashBoard = "dashboard/monthly";
  final String totaldashBoard = "dashboard/monthlyTotal";
}
