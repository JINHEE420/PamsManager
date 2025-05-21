class PamsOptionModel {
  int? uid = 0;
  String? id = "";
  bool? isSaveId = true;
  String? searchDay = "";
  int? searchEquipCode = 0;
  String? searchLoc = "";

  PamsOptionModel(
      {this.uid, this.id, this.isSaveId, this.searchDay, this.searchEquipCode, this.searchLoc});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = uid;
    if (id != null) {
      map['id'] = id;
    } else {
      map['id'] = "";
    }
    map['isSaveId'] = isSaveId! ? 1 : 0;
    if(searchDay != null) {
      map['searchDay'] = searchDay;
    } else {
      map['searchDay'] = "";
    }
    map['searchEquipCode'] = searchEquipCode;
    if(searchLoc != null) {
      map['searchLoc'] = searchLoc;
    } else {
      map['searchLoc'] = "";
    }
    return map;
  }

  PamsOptionModel.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.id = map['id'];
    this.isSaveId = map['isSaveId'] == 1 ? true : false;
    this.searchDay = map['searchDay'];
    this.searchEquipCode = map['searchEquipCode'];
    this.searchLoc = map['searchLoc'];
  }
}