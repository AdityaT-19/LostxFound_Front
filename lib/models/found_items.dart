import 'dart:convert';

import 'package:lostxfound_front/models/locations.dart';

class FoundItem {
  late String uid;
  late String sname;
  late int fid;
  late String fname;
  late String fdescription;
  late String fimage;
  late DateTime fdate;
  late Location location;
  FoundItem({
    required this.uid,
    required this.sname,
    required this.fid,
    required this.fname,
    required this.fdescription,
    required this.fimage,
    required this.fdate,
    required this.location,
  });
  static fromJson(dynamic json) {
    final fdate = DateTime.parse(json['fdate']);
    final location = Location.fromJson(json['location']);
    return FoundItem(
      uid: json['uid'],
      sname: json['sname'],
      fid: json['fid'],
      fname: json['fname'],
      fdescription: json['fdescription'],
      fimage: json['fimage'],
      fdate: fdate,
      location: location,
    );
  }

  toJson() {
    return {
      'uid': uid,
      'sname': sname,
      'fid': fid,
      'fname': fname,
      'fdescription': fdescription,
      'fimage': fimage,
      'fdate': fdate,
      'location': location,
    };
  }
}

class FoundItemIns {
  late String fname;
  late String fdescription;
  late String fimage;
  late DateTime fdate;
  late int locid;
  late String locdesc;
  late String uid;
  FoundItemIns({
    required this.fname,
    required this.fdescription,
    required this.fimage,
    required this.fdate,
    required this.locid,
    required this.locdesc,
    required this.uid,
  });
  fromJson(Map<String, dynamic> json) {
    return FoundItemIns(
      fname: json['fname'],
      fdescription: json['fdescription'],
      fimage: json['fimage'],
      fdate: json['fdate'],
      locid: json['locid'],
      locdesc: json['locdesc'],
      uid: json['uid'],
    );
  }

  toJson() {
    final date = '${fdate.year}-${fdate.month}-${fdate.day}';

    return jsonEncode({
      'fname': fname,
      'fdescription': fdescription,
      'fimage': fimage,
      'fdate': date,
      'locid': locid,
      'locdesc': locdesc,
      'uid': uid,
    });
  }
}
