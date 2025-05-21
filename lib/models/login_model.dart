class LoginModel {
  int? uid = 0;
  String? id = "";
  bool? isSaveId = true;

  LoginModel({this.uid, this.id, this.isSaveId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = uid;
    if (id != null) {
      map['id'] = id;
    }
    map['isSaveId'] = isSaveId!;
    return map;
  }

  LoginModel.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.id = map['id'];
    this.isSaveId = map['isSaveId'];
  }
}
