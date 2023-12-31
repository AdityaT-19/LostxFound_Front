import 'dart:convert';

import 'package:lostxfound_front/constants/url.dart';
import 'package:lostxfound_front/models/found_items.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoundItemsAllProvider extends StateNotifier<List<FoundItem>> {
  FoundItemsAllProvider() : super([]);

  void fetchAndSetFoundItemsByLostItems(String uid) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/founditems/lostitems/$uid');
    final response = await http.get(url);
    final List<FoundItem> loadedFoundItems = [];
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData) as List<dynamic>;
    for (var value in decodedData) {
      loadedFoundItems.add(
        FoundItem.fromJson(value),
      );
    }
    state = loadedFoundItems;
  }

  void fetchAndSetFoundItemsByUser(String uid) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/founditems/user/$uid');
    final response = await http.get(url);
    final List<FoundItem> loadedFoundItems = [];
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData) as List<dynamic>;
    for (var value in decodedData) {
      loadedFoundItems.add(
        FoundItem.fromJson(value),
      );
    }
    state = loadedFoundItems;
  }

  void addFoundItem(FoundItemIns foundItem) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/founditems');
    final data = foundItem.toJson();
    final response = await http.post(url, body: (data), headers: {
      'Content-Type': 'application/json',
    });
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData);
    final newFoundItem = FoundItem.fromJson(decodedData);
    state = [...state, newFoundItem];
  }
}

final foundItemsAllProvider =
    StateNotifierProvider<FoundItemsAllProvider, List<FoundItem>>(
        (ref) => FoundItemsAllProvider());
