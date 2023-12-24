class User {
  int univid;
  String uid;
  String sname;
  String email;
  String address;
  int phone;
  int lostitems;
  int founditems;
  User({
    required this.univid,
    required this.uid,
    required this.sname,
    required this.email,
    required this.address,
    required this.phone,
    required this.lostitems,
    required this.founditems,
  });
  static fromJson(dynamic json) {
    return User(
      univid: json['univid'],
      uid: json['uid'],
      sname: json['sname'],
      email: json['email'],
      address: json['address'],
      phone: json['phno'],
      lostitems: json['lostcount'],
      founditems: json['foundcount'],
    );
  }
}
