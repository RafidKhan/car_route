import 'package:geocoding/geocoding.dart';

extension LocationExt on String {
  Future<Location?> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
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
