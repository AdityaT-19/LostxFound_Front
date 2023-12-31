import 'dart:convert';

import 'package:lostxfound_front/constants/url.dart';
import 'package:lostxfound_front/models/lost_item.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LostItemsAllProvider extends StateNotifier<List<LostItem>> {
  LostItemsAllProvider() : super([]) {
    fetchAndSetLostItems();
  }

  void fetchAndSetLostItems() async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/lostitems');
    final response = await http.get(url);
    final List<LostItem> loadedLostItems = [];
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData) as List<dynamic>;
    for (var value in decodedData) {
      loadedLostItems.add(
        LostItem.fromJson(value),
      );
    }
    state = loadedLostItems;
  }

  void addLostItem(LostItemIns lostItem) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/lostitems');
    final data = lostItem.toJson();

    final response = await http.post(url, body: (data), headers: {
      'Content-Type': 'application/json',
    });
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData);
    final newLostItem = LostItem.fromJson(decodedData);
    state = [...state, newLostItem];
  }

  void removeLostItem(LostItem lostItem) async {
    final univid = 1;
    final url = Uri.parse('$URL/$univid/lostitems/${lostItem.lid}');
    final response = await http.delete(url);
    state = state.where((element) => element.lid != lostItem.lid).toList();
  }

  void fetchLostItemsByUser(String uid) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/lostitems/user/$uid');
    final response = await http.get(url);
    final List<LostItem> loadedLostItems = [];
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData) as List<dynamic>;
    for (var value in decodedData) {
      loadedLostItems.add(
        LostItem.fromJson(value),
      );
    }
    state = loadedLostItems;
  }

  void fetchRecentLostItems() async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/lostitems/recent');
    final response = await http.get(url);
    final List<LostItem> loadedLostItems = [];
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData) as List<dynamic>;
    for (var value in decodedData) {
      loadedLostItems.add(
        LostItem.fromJson(value),
      );
    }
    state = loadedLostItems;
  }

  void updateLostItem(int lid, String prop, dynamic val) async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/lostitems/$lid');
    final data = {prop: val};
    final response = await http.put(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData);
    final newLostItem = LostItem.fromJson(decodedData);
    state = state.map((e) => e.lid == lid ? newLostItem : e).toList();
  }
}

final lostItemsAllProvider =
    StateNotifierProvider<LostItemsAllProvider, List<LostItem>>(
        (ref) => LostItemsAllProvider());
