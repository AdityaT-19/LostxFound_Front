class Camids {
  int camid;
  Camids({
    required this.camid,
  });
  static Camids fromJson(dynamic json) {
    return Camids(
      camid: json['camid'],
    );
  }

  toJson() {
    return {
      'camid': camid,
    };
  }
}

class Location {
  late int locid;
  String? locdesc;
  late String bname;
  late int floor;
  late String aname;
  late List<Camids> camids;
  Location({
    required this.locid,
    this.locdesc,
    required this.bname,
    required this.floor,
    required this.aname,
    required this.camids,
  });
  static Location fromJson(dynamic json) {
    final List<Camids> camids = [];
    for (var value in json['camids']) {
      camids.add(Camids.fromJson(value));
    }
    return Location(
      locid: json['locid'],
      locdesc: json['locdesc'],
      bname: json['bname'],
      floor: json['floor'],
      aname: json['aname'],
      camids: camids,
    );
  }

  toJson() {
    return {
      'locid': locid,
      'locdesc': locdesc,
      'bname': bname,
      'floor': floor,
      'aname': aname,
      'camids': camids,
    };
  }
}

class LostLocationIns {
  late int locid;
  String? locdesc;
  LostLocationIns({
    required this.locid,
    this.locdesc,
  });
  LostLocationIns fromJson(Map<String, dynamic> json) {
    return LostLocationIns(
      locid: json['locid'],
      locdesc: json['locdesc'],
    );
  }

  toJson() {
    return {
      'locid': locid,
      'locdesc': locdesc,
    };
  }
}
