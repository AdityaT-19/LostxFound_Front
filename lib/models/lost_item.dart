import 'dart:convert';

import 'package:lostxfound_front/models/locations.dart';

class LostItem {
  late String uid;
  late String sname;
  late int lid;
  late String lname;
  late String ldescription;
  late String liimage;
  late DateTime ldate;
  late List<Location>? probablyLost;
  LostItem({
    required this.uid,
    required this.sname,
    required this.lid,
    required this.lname,
    required this.ldescription,
    required this.liimage,
    required this.ldate,
    this.probablyLost,
  });
  static LostItem fromJson(dynamic json) {
    final ldate = DateTime.parse(json['ldate']);
    final List<Location> probablyLost = [];
    for (var value in json['location']) {
      probablyLost.add(Location.fromJson(value));
    }
    return LostItem(
      uid: json['uid'],
      sname: json['sname'],
      lid: json['lid'],
      lname: json['lname'],
      ldescription: json['ldescription'],
      liimage: json['liimage'],
      ldate: ldate,
      probablyLost: probablyLost,
    );
  }

  toJson() {
    return {
      'uid': uid,
      'sname': sname,
      'lid': lid,
      'lname': lname,
      'ldescription': ldescription,
      'liimage': liimage,
      'ldate': ldate,
      'probablyLost': probablyLost,
    };
  }
}

class LostItemIns {
  late String lname;
  late String ldescription;
  late String liimage;
  late DateTime ldate;
  late String uid;
  List<LostLocationIns>? probabilyLostLocation;
  LostItemIns({
    required this.lname,
    required this.ldescription,
    required this.liimage,
    required this.ldate,
    required this.uid,
    this.probabilyLostLocation,
  });
  static fromJson(Map<String, dynamic> json) {
    return LostItemIns(
      lname: json['lname'],
      ldescription: json['ldescription'],
      liimage: json['liimage'],
      ldate: json['ldate'],
      uid: json['uid'],
      probabilyLostLocation: json['probabily_lost_location'],
    );
  }

  toJson() {
    final date = '${ldate.year}-${ldate.month}-${ldate.day}';
    var probabily_lost_location;
    if (probabilyLostLocation != null) {
      probabily_lost_location = [];
      for (var value in probabilyLostLocation!) {
        probabily_lost_location.add(value.toJson());
      }
    }
    return jsonEncode({
      'lname': lname,
      'ldescription': ldescription,
      'liimage': liimage,
      'ldate': date,
      'uid': uid,
      'probabily_lost_location': probabilyLostLocation,
    });
  }
}
