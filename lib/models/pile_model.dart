
import 'package:flutter/cupertino.dart';

class PileModel {
  int? code = 0;
  String? number = "";
  String? location = "";
  String? totalAmount = "";
  String? avgAmount = "";
  String? avgRebound = "";
  String? remainingLength = "";
  bool? inspection = false;
  String? checkingLength = "";

  PileModel({this.code, this.number, this.location, this.totalAmount, this.avgAmount, this.avgRebound,
    this.inspection, this.remainingLength, this.checkingLength});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['code'] = code;
    if(number != null) {
      map['number'] = number;
    }
    if(location != null) {
      map['location'] = location;
    }
    if(totalAmount != null) {
      map['totalAmount'] = totalAmount;
    }
    if(avgAmount != null) {
      map['avgAmount'] = avgAmount;
    }
    if(avgRebound != null) {
      map['avgRebound'] = avgRebound;
    }
    map['inspection'] = inspection;
    if(remainingLength != null) {
      map['remainingLength'] = remainingLength;
    }
    if(checkingLength != null) {
      map['checkingLength'] = checkingLength;
    }
    return map;
  }

  PileModel.fromMap(Map<String, dynamic> map) {
    this.code = map['code'];
    this.number = map['number'];
    this.location = map['location'];
    this.totalAmount = map['totalAmount'];
    this.avgAmount = map['avgAmount'];
    this.avgRebound = map['avgRebound'];
    this.inspection = map['inspection'];
    this.remainingLength = map['remainingLength'];
    this.checkingLength = map['checkingLength'];
  }
}