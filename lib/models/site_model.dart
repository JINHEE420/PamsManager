
class SiteModel {
  int? code = 0;
  String? name = "";

  SiteModel({this.code, this.name});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['code'] = code;
    if(name != null) {
      map['name'] = name;
    }
    return map;
  }

  SiteModel.fromMap(Map<String, dynamic> map) {
    this.code = map['code'];
    this.name = map['name'];
  }
}