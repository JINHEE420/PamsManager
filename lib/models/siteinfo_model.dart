class SiteInfoModel {
  int? pileCnt = 0;
  int? pileCompleteCnt = 0;
  String? name = "";

  SiteInfoModel({this.pileCnt, this.pileCompleteCnt, this.name});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['pileCnt'] = pileCnt;
    map['pileCompleteCnt'] = pileCompleteCnt;
    map['name'] = name;
    return map;
  }

  SiteInfoModel.fromMap(Map<String, dynamic> map) {
    this.pileCnt = map['pileCnt'];
    this.pileCompleteCnt = map['pileCompleteCnt'];
    this.name = map['name'];
  }
}
