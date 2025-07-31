import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

extension LocationExt on String {
  Future<Location?> getLocationFromAddress() async {
    try {
      List<Location> locations = await locationFromAddress(this);
      if (locations.isNotEmpty) {
        return locations.first;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

extension Print on Object {
  void printLog() {
    if (kDebugMode) {
      log(toString());
    }
  }
}
