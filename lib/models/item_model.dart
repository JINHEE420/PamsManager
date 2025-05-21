class ItemModel {
  String? name;
  int? code;

  ItemModel({ this.code, this.name });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(code != null) {
      map['code'] = code;
    }
    map['name'] = name!;
    return map;
  }

  ItemModel.fromMap(Map<String, dynamic> map) {
    this.code = map['code'];
    this.name = map['name'];
  }
}