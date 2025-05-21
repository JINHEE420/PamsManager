class DashBoardModel {
  final String today;
  final List<Equip> states;

  DashBoardModel({required this.today, required this.states});

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    var list = json['states'] as List;
    List<Equip> equipList = list.map((i) => Equip.fromJson(i)).toList();

    return DashBoardModel(
      today: json['today'] ?? "",
      states: equipList ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'states': states.map((equip) => equip.toJson()).toList(),
    };
  }
}

class Equip {
  final int equipCode;
  final String equipName;
  final String totalQty;
  final String monthQty;
  final List<Day> days;

  Equip({
    required this.equipCode,
    required this.equipName,
    required this.totalQty,
    required this.monthQty,
    required this.days,
  });

  factory Equip.fromJson(Map<String, dynamic> json) {
    var list = json['days'] as List;
    List<Day> daysList = list.map((i) => Day.fromJson(i)).toList();

    return Equip(
      equipCode: json['equipCode'] ?? "",
      equipName: json['equipName'] ?? "",
      totalQty: json['totalQty'] ?? "",
      monthQty: json['monthQty'] ?? "",
      days: daysList ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipCode': equipCode,
      'equipName': equipName,
      'totalQty': totalQty,
      'monthQty': monthQty,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }
}

class Day {
  final String date;
  final String day;
  final String qty;

  Day({required this.date, required this.day, required this.qty});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: json['date'] ?? "",
      day: json['day'] ?? "",
      qty: json['qty'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'qty': qty,
    };
  }
}
