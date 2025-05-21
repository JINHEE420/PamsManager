class SearchModel {
  String? day = "";
  String? location = "";
  bool? isNotInspection = true;
  bool? isCompInspection = true;

  SearchModel(
      {this.day, this.location, this.isNotInspection, this.isCompInspection});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (day != null) {
      map['day'] = day;
    }
    if (location != null) {
      map['location'] = location;
    }
    map['isNotInspection'] = isNotInspection!;
    map['isCompInspection'] = isCompInspection;
    return map;
  }

  SearchModel.fromMap(Map<String, dynamic> map) {
    this.day = map['day'];
    this.location = map['location'];
    this.isNotInspection = map['isNotInspection'];
    this.isCompInspection = map['isCompInspection'];
  }
}
