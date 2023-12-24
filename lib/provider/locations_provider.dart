import 'dart:convert';

import 'package:lostxfound_front/constants/url.dart';
import 'package:lostxfound_front/models/locations.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationsProvider extends StateNotifier<List<Location>> {
  LocationsProvider() : super([]) {
    fetchAndSetLocations();
  }

  void fetchAndSetLocations() async {
    final unvid = 1;
    final url = Uri.parse('$URL/$unvid/locations');
    final response = await http.get(url);
    final extractedData = response.body;
    final decodedData = jsonDecode(extractedData);
    final List<Location> loadedLocations = [];
    decodedData.forEach((location) {
      loadedLocations.add(Location.fromJson(location));
    });
    state = loadedLocations;
  }
}

final locationsProvider =
    StateNotifierProvider<LocationsProvider, List<Location>>(
  (ref) => LocationsProvider(),
);
