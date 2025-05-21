class EquipListModel {
  int? code = 0;
  String? name;
  String? operator;
  String? size;
  bool? isUse;
  String? updateDt;

  EquipListModel({
    this.code,
    this.name,
    this.operator,
    this.size,
    this.isUse,
    this.updateDt,
  });

  // 객체 비교를 위해 == 연산자 오버라이드
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EquipListModel && other.code == code);

  @override
  int get hashCode => code.hashCode;

  factory EquipListModel.fromJson(Map<String, dynamic> json) {
    return EquipListModel(
      code: json['code'] as int?,
      name: json['name'] as String?,
      operator: json['operator'] as String?,
      size: json['size'] as String?,
      isUse: json['isUse'] as bool?,
      updateDt: json['updateDt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'operator': operator,
      'size': size,
      'isUse': isUse,
      'updateDt': updateDt,
    };
  }
}
