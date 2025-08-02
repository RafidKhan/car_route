import 'dart:developer';

import 'package:car_route/modules/home_page/model/custom_lat_long.dart';
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

extension LocationExt2 on CustomLatLong {
  Future<String> getAddressFromLatLng() async {
    try {
      final places = await placemarkFromCoordinates(lat, long);

      if (places.isNotEmpty) {
        final place = places.first;

        return "${place.name}, ${place.street}, ${place.locality}, "
            "${place.postalCode}, ${place.country}";
      } else {
        return "No address available";
      }
    } catch (e) {
      return "Failed to get address";
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
