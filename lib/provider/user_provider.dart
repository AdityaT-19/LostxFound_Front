import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lostxfound_front/models/users.dart';
import 'package:http/http.dart' as http;

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null) {
    fetchAndSetUser();
  }

  void fetchAndSetUser() async {
    final unvid = 1;
    final uid = "01JCE21CS001";
    final url = Uri.parse('http://10.0.2.2:3000/$unvid/users/$uid');
    final response = await http.get(url);
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData);
    final newUser = User.fromJson(decodedData);
    state = newUser;
  }
}

final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
