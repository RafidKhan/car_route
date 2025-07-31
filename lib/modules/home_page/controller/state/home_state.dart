import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';

class HomeState {
  final Location? startLocation;
  final Location? destinationLocation;
  final bool isButtonEnabled;
  final MapController? mapController;

  const HomeState({
    this.startLocation,
    this.destinationLocation,
    this.isButtonEnabled = false,
    this.mapController,
  });

  HomeState copyWith({
    Location? startLocation,
    Location? destinationLocation,
    bool? isButtonEnabled,
    MapController? mapController,
  }) {
    return HomeState(
      startLocation: startLocation ?? this.startLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      mapController: mapController ?? this.mapController,
    );
  }
}
