class RecordModel {
  String? constDay = "";
  String? equipName = "";
  String? number = "";
  String? location = "";
  double? hammerW = 0;
  double? depth = 0;
  double? length = 0;
  double? fallH = 0;
  double? totalAmount = 0;
  double? avgAmount = 0;
  double? avgRebound = 0;
  double? efficiency = 0;
  String? logData = "";

  RecordModel(
      {this.constDay,
      this.equipName,
      this.number,
      this.location,
      this.hammerW,
      this.depth,
      this.length,
      this.fallH,
      this.totalAmount,
      this.avgAmount,
      this.avgRebound,
      this.efficiency,
      this.logData});
}
