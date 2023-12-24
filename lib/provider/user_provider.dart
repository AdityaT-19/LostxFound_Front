import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lostxfound_front/constants/url.dart';
import 'package:lostxfound_front/models/users.dart';
import 'package:http/http.dart' as http;

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);

  void fetchAndSetUser(String uid) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/user/$uid');
    final response = await http.get(url);
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData);
    print(decodedData.toString());
    final newUser = User.fromJson(decodedData);
    state = newUser;
  }
}

final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
